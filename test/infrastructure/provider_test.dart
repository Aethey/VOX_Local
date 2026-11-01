import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/domain/failure.dart';
import 'package:vox_local/domain/models.dart';
import 'package:vox_local/infrastructure/chat_provider.dart';

import '../fakes.dart';

class FixtureAdapter implements HttpClientAdapter {
  FixtureAdapter(this.handle);
  final FutureOr<ResponseBody> Function(RequestOptions) handle;
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async => handle(options);
  @override
  void close({bool force = false}) {}
}

ChatCompletionProvider client(
  FutureOr<ResponseBody> Function(RequestOptions) handler,
) => ChatCompletionProvider(
  clientFactory: () => Dio()..httpClientAdapter = FixtureAdapter(handler),
);
ResponseBody response(
  int code,
  Object body, {
  Map<String, List<String>> headers = const {},
}) => ResponseBody.fromString(
  jsonEncode(body),
  code,
  headers: {
    Headers.contentTypeHeader: ['application/json'],
    ...headers,
  },
);
void main() {
  test(
    'generated client preserves base path and authorization only in header',
    () async {
      final provider = client((r) {
        expect(r.uri.toString(), 'https://example.invalid/v1/chat/completions');
        expect(r.headers['Authorization'], 'Bearer synthetic-fixture');
        expect(jsonEncode(r.data), isNot(contains('synthetic-fixture')));
        return response(200, {
          'choices': [
            {
              'finish_reason': 'stop',
              'message': {'content': '{"matched":false,"findings":[]}'},
            },
          ],
        });
      });
      expect(
        (await provider.analyze(job(), 'synthetic-fixture')).matched,
        false,
      );
    },
  );
  test('system prompt follows the job language and keeps the rules', () async {
    for (final (language, marker) in [
      ('zh', '用中文撰写'),
      ('ja', '日本語で書いてください'),
      ('en', 'in English'),
    ]) {
      final provider = client((r) {
        final system = (r.data['messages'] as List).first['content'] as String;
        expect(system, contains(marker));
        expect(system, contains(AnalysisTemplate.presets.first.instruction));
        expect(system, contains('"evidenceSegmentIds"'));
        return response(200, {
          'choices': [
            {
              'finish_reason': 'stop',
              'message': {'content': '{"matched":false,"findings":[]}'},
            },
          ],
        });
      });
      await provider.analyze(
        job().copyWith(language: language),
        'synthetic-fixture',
      );
    }
  });
  test('401 maps to credentials and does not expose response body', () async {
    final provider = client(
      (_) => response(401, {'error': 'private-response-marker'}),
    );
    await expectLater(
      provider.analyze(job(), 'synthetic-fixture'),
      throwsA(
        isA<AppFailure>()
            .having((e) => e.kind, 'kind', FailureKind.credentials)
            .having(
              (e) => e.message,
              'message',
              isNot(contains('private-response-marker')),
            ),
      ),
    );
  });
  test('429 parses Retry-After', () async {
    final p = client(
      (_) => response(
        429,
        {},
        headers: {
          'retry-after': ['17'],
        },
      ),
    );
    await expectLater(
      p.analyze(job(), 'synthetic-fixture'),
      throwsA(
        isA<AppFailure>().having(
          (e) => e.retryAfter,
          'retryAfter',
          const Duration(seconds: 17),
        ),
      ),
    );
  });
  test('model list decoded by generated API', () async {
    final p = client((r) {
      expect(r.uri.path, '/v1/models');
      return response(200, {
        'data': [
          {'id': 'b'},
          {'id': 'a'},
          {'id': 'a'},
        ],
      });
    });
    expect(await p.models(profile, 'synthetic-fixture'), ['a', 'b']);
  });
  test('truncated completion is not accepted', () async {
    final p = client(
      (_) => response(200, {
        'choices': [
          {
            'finish_reason': 'length',
            'message': {'content': '{}'},
          },
        ],
      }),
    );
    await expectLater(
      p.analyze(job(), 'synthetic-fixture'),
      throwsA(
        isA<AppFailure>().having(
          (e) => e.kind,
          'kind',
          FailureKind.invalidResponse,
        ),
      ),
    );
  });
  test('unknown evidence is not accepted', () async {
    final p = client(
      (_) => response(200, {
        'choices': [
          {
            'finish_reason': 'stop',
            'message': {
              'content': '{"matched":true,"findings":[{"topic":"x","summary":"y","evidenceSegmentIds":["invented"]}]}',
            },
          },
        ],
      }),
    );
    await expectLater(
      p.analyze(job(), 'synthetic-fixture'),
      throwsA(isA<AppFailure>()),
    );
  });
  test('redirects are disabled to prevent forwarding credentials', () async {
    final p = client((r) {
      expect(r.followRedirects, false);
      return response(302, {});
    });
    await expectLater(
      p.analyze(job(), 'synthetic-fixture'),
      throwsA(isA<AppFailure>()),
    );
  });
  test('oversize responses are bounded', () async {
    final p = client(
      (_) => ResponseBody.fromString(
        List.filled(530000, 'x').join(),
        200,
        headers: {
          Headers.contentTypeHeader: ['application/json'],
        },
      ),
    );
    await expectLater(
      p.analyze(job(), 'synthetic-fixture'),
      throwsA(
        isA<AppFailure>().having(
          (e) => e.kind,
          'kind',
          FailureKind.invalidResponse,
        ),
      ),
    );
  });
}
