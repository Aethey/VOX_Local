import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';

typedef AvatarCard = ({String id, String name});
typedef AvatarServerSettings = ({bool hasApiKey, List<AvatarCard> cards});

class AvatarServer {
  AvatarServer(this.uri, this._token, {HttpClientAdapter? adapter})
    : _http = Dio(
        BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          sendTimeout: const Duration(seconds: 5),
          followRedirects: false,
        ),
      ) {
    _http.httpClientAdapter =
        adapter ??
        IOHttpClientAdapter(
          createHttpClient: () => HttpClient()..findProxy = (_) => 'DIRECT',
        );
  }

  final Uri uri;
  final String _token;
  final Dio _http;
  String? _pendingEnd;

  Future<AvatarServerSettings> settings(CancelToken cancel) async {
    final response = await _request<Map<String, dynamic>>(
      'GET',
      'settings',
      cancel: cancel,
    );
    final body = response.data;
    final cards = body?['cards'];
    final hasApiKey = body?['hasApiKey'];
    if (cards is! List || hasApiKey is! bool) {
      throw const FormatException('Invalid voice settings');
    }
    return (
      hasApiKey: hasApiKey,
      cards: [
        for (final entry in cards)
          if (entry case {'id': final String id, 'name': final String name}
              when id.isNotEmpty && id != 'none')
            (id: id, name: name.isEmpty ? id : name),
      ],
    );
  }

  Future<String> createSession(
    String id,
    String offer, {
    required String card,
    required CancelToken cancel,
  }) async {
    final data = {'id': id, 'sdp': offer, 'language': 'auto', 'card': card};
    final request = jsonEncode(data);
    if (utf8.encode(request).length > 64 * 1024) {
      throw const FormatException('Voice offer too large');
    }
    const timeout = Duration(seconds: 42);
    final response =
        await _request<Map<String, dynamic>>(
          'POST',
          'session',
          body: request,
          receiveTimeout: timeout,
          cancel: cancel,
        ).timeout(
          timeout,
          onTimeout: () {
            cancel.cancel();
            throw TimeoutException('Voice offer timed out', timeout);
          },
        );
    final answer = response.data?['sdp'];
    if (answer is! String || answer.trim().isEmpty) {
      throw const FormatException('Missing WebRTC answer');
    }
    return answer;
  }

  Stream<({String type, String? message})> events(
    String id,
    CancelToken cancel,
  ) async* {
    final response = await _request<ResponseBody>(
      'GET',
      'session/$id/events',
      cancel: cancel,
      accept: 'text/event-stream',
      responseType: ResponseType.stream,
      // The server sends SSE keepalive comments even when the call is quiet.
      receiveTimeout: const Duration(seconds: 45),
    );
    final contentType = response.headers.value(Headers.contentTypeHeader);
    if (contentType?.split(';').first.trim().toLowerCase() !=
        'text/event-stream') {
      throw const FormatException('Expected a server-sent event stream');
    }
    final bytes = response.data?.stream;
    if (bytes == null) throw const FormatException('Missing event stream');

    final data = <String>[];
    await for (final line
        in bytes
            .cast<List<int>>()
            .transform(utf8.decoder)
            .transform(const LineSplitter())) {
      if (line.isEmpty) {
        if (data.isNotEmpty) {
          final event = jsonDecode(data.join('\n'));
          data.clear();
          if (event case {'type': final String type}) {
            final message = event['message'];
            yield (
              type: type,
              message: message is String ? _publicMessage(message) : null,
            );
          }
        }
      } else if (line.startsWith('data:')) {
        final text = line.substring(5);
        data.add(text.startsWith(' ') ? text.substring(1) : text);
      }
    }
  }

  Future<void> endSession(String id) async {
    // A lost DELETE response can leave the PC's single call slot occupied.
    _pendingEnd = id;
    final cancel = CancelToken();
    const timeout = Duration(seconds: 4);
    try {
      await _request<void>(
        'DELETE',
        'session/$id',
        cancel: cancel,
        receiveTimeout: timeout,
      ).timeout(timeout);
    } on AvatarServerException catch (error) {
      if (error.status != 404) rethrow;
    } finally {
      cancel.cancel();
    }
    _pendingEnd = null;
  }

  Future<void> retryPendingEnd() async {
    final id = _pendingEnd;
    if (id != null) await endSession(id);
  }

  Future<Response<T>> _request<T>(
    String method,
    String path, {
    String? body,
    CancelToken? cancel,
    String accept = 'application/json',
    ResponseType responseType = ResponseType.json,
    Duration receiveTimeout = const Duration(seconds: 8),
  }) async {
    try {
      return await _http.requestUri<T>(
        uri.replace(path: '/api/voice/$path'),
        data: body,
        cancelToken: cancel,
        options: Options(
          method: method,
          headers: {'Authorization': 'Bearer $_token', 'Accept': accept},
          contentType: body == null ? null : Headers.jsonContentType,
          responseType: responseType,
          receiveTimeout: receiveTimeout,
        ),
      );
    } on DioException catch (failure) {
      final response = failure.response;
      final status = response?.statusCode;
      var data = response?.data;
      if (data is ResponseBody) {
        final buffer = StringBuffer();
        await for (final chunk in data.stream.cast<List<int>>().transform(
          utf8.decoder,
        )) {
          buffer.write(chunk);
          if (buffer.length > 4096) break;
        }
        data = buffer.toString();
      }
      if (data is String) {
        try {
          data = jsonDecode(data);
        } on FormatException {
          data = null;
        }
      }
      final message = data is Map ? data['error'] : null;
      throw AvatarServerException(
        status,
        message is String ? _publicMessage(message) : null,
      );
    }
  }

  String? _publicMessage(String raw) {
    final text = raw.replaceAll(_token, '…').trim();
    if (text.isEmpty) return null;
    return String.fromCharCodes(text.runes.take(200));
  }

  void close() => _http.close(force: true);
}

class AvatarServerException implements Exception {
  const AvatarServerException(this.status, this.message);

  final int? status;
  final String? message;

  bool get retryable => switch (status) {
    null || 408 || (>= 500 && < 600) => true,
    _ => false,
  };

  String get displayMessage => switch (status) {
    400 || 413 || 415 => 'サーバーが通話リクエストを受け付けませんでした。',
    401 => message ?? '最新のアクセス用トークンと PC 側の API キー設定を確認してください。',
    403 => message ?? '接続が拒否されました。同じネットワークに接続しているか確認してください。',
    404 => message ?? 'サーバーのアドレスと選択したキャラクターカードを確認してください。',
    409 => 'サーバーで別の通話が進行中です。その通話を終了してからお試しください。',
    429 => '音声サービスの利用上限に達しました。時間をおいてお試しください。',
    502 || 503 || 504 => 'サーバーから音声サービスに接続できませんでした。',
    null => 'サーバーに接続できませんでした。アドレスとネットワークを確認してください。',
    _ => 'サーバーでエラーが発生しました（HTTP $status）。',
  };
}
