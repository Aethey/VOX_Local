import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vox_local/application/avatar_conversation.dart';
import 'package:vox_local/infrastructure/avatar_server.dart';

void main() {
  _callTest('short WebRTC disconnect recovers on the same call', (f) async {
    await f.connectionState('disconnected');
    expect(f.avatar.link, AvatarLink.reconnecting);
    expect(f.avatar.level.value, 0);
    await f.pump(const Duration(seconds: 2));
    await f.connectionState('connected');
    expect(f.avatar.link, AvatarLink.inCall);
    await f.pump(const Duration(seconds: 8));
    expect(f.backend.offers, hasLength(1));
    expect(f.backend.deletes, isEmpty);
  });

  _callTest(
    'persistent WebRTC disconnect releases the old session before redial',
    (f) async {
      final old = f.backend.offers.single;
      await f.connectionState('disconnected');
      expect(f.avatar.link, AvatarLink.reconnecting);
      await f.pump(const Duration(seconds: 3));
      expect(f.backend.deletes, isEmpty);
      await f.connectionState('disconnected');
      await f.pump(const Duration(seconds: 1));
      expect(f.backend.deletes, [old]);
      await f.pump(const Duration(seconds: 1));
      expect(f.backend.deletes, [old]);
      expect(f.backend.offers, hasLength(2));
      expect(f.backend.offers.last, isNot(old));
      await f.ready();
      expect(f.avatar.link, AvatarLink.inCall);
    },
  );

  _callTest('silent SSE stalls while the peer still reports connected', (
    f,
  ) async {
    await f.pump(const Duration(seconds: 40));
    f.backend.send(': keepalive\n\n');
    await f.pump(Duration.zero);
    await f.pump(const Duration(seconds: 40));
    expect(f.avatar.link, AvatarLink.inCall);
    await f.pump(const Duration(seconds: 5));
    expect(f.avatar.link, AvatarLink.reconnecting);
    await f.pump(const Duration(seconds: 1));
    expect(f.backend.offers, hasLength(2));
  });

  _callTest('upstream closed event and a transient retry recover the call', (
    f,
  ) async {
    f.backend.offerErrors.add(503);
    f.backend.send(
      'data: {"type":"closed","message":"电脑与 Codex 的音频连接已断开。"}\n\n',
    );
    await f.pump(Duration.zero);
    expect(f.avatar.link, AvatarLink.reconnecting);
    await f.pump(const Duration(seconds: 1));
    await f.pump(const Duration(seconds: 3));
    expect(f.backend.offers, hasLength(3));
    await f.ready();
    expect(f.avatar.link, AvatarLink.inCall);
  });

  _callTest('expired credentials stop the automatic retries', (f) async {
    f.backend.offerErrors.add(401);
    await f.connectionState('failed');
    await f.pump(const Duration(seconds: 1));
    expect(f.avatar.link, AvatarLink.connected);
    expect(f.avatar.notice, contains('トークン'));
    await f.pump(const Duration(seconds: 8));
    expect(f.backend.offers, hasLength(2));
  });

  _callTest('user hangup cancels queued reconnect', (f) async {
    await f.connectionState('failed');
    expect(f.avatar.link, AvatarLink.reconnecting);
    await f.avatar.hangUp();
    await f.pump(const Duration(seconds: 8));
    expect(f.avatar.link, AvatarLink.connected);
    expect(f.backend.offers, hasLength(1));
  });

  _callTest('a timed-out DELETE is retried before claiming the call slot', (
    f,
  ) async {
    final old = f.backend.offers.single;
    f.backend.stallNextDelete = true;
    await f.connectionState('failed');
    await f.pump(const Duration(seconds: 4));
    expect(f.backend.deletes, [old]);
    expect(f.backend.offers, [old]);
    await f.pump(const Duration(seconds: 1));
    expect(f.backend.deletes, [old, old]);
    expect(f.backend.offers, hasLength(2));
    await f.ready();
    expect(f.avatar.link, AvatarLink.inCall);
  });

  _callTest('cancelled redial releases the late offer before a manual call', (
    f,
  ) async {
    final offer = f.backend.holdNextOffer = Completer<void>();
    await f.connectionState('failed');
    await f.pump(const Duration(seconds: 1));
    expect(f.backend.offers, hasLength(2));
    final cancelled = f.backend.offers.last;

    await f.avatar.hangUp();
    expect(f.avatar.link, AvatarLink.connected);
    final manualCall = f.avatar.startCall();
    await f.pump(Duration.zero);
    expect(f.backend.offers, hasLength(2));
    offer.complete();
    await f.pump(Duration.zero);
    expect(f.backend.deletes, contains(cancelled));
    expect(f.backend.offers, hasLength(3));
    await manualCall;
    await f.ready();
    expect(f.avatar.link, AvatarLink.inCall);
  });

  _callTest('two transient failures exhaust the automatic retries', (f) async {
    f.backend.offerErrors.addAll([503, 503]);
    final closed = f.backend.endEvents();
    await f.pump(Duration.zero);
    await closed;
    expect(f.avatar.link, AvatarLink.reconnecting);
    await f.pump(const Duration(seconds: 1));
    await f.pump(const Duration(seconds: 3));
    expect(f.avatar.link, AvatarLink.connected);
    expect(f.avatar.notice, contains('再接続できませんでした'));
    await f.pump(const Duration(seconds: 10));
    expect(f.backend.offers, hasLength(3));
  });

  _callTest('recovery has a deadline even while an offer is pending', (
    f,
  ) async {
    f.backend.holdNextOffer = Completer<void>();
    await f.connectionState('failed');
    await f.pump(const Duration(seconds: 1));
    await f.pump(const Duration(seconds: 42));
    expect(f.avatar.link, AvatarLink.reconnecting);

    final lateOffer = f.backend.holdNextOffer = Completer<void>();
    await f.pump(const Duration(seconds: 3));
    expect(f.backend.offers, hasLength(3));
    await f.pump(const Duration(seconds: 14));
    expect(f.avatar.link, AvatarLink.connected);
    expect(f.avatar.notice, contains('再接続できませんでした'));
    lateOffer.complete();
    await f.pump(Duration.zero);
    expect(f.backend.deletes, contains(f.backend.offers.last));
  });
}

void _callTest(String name, Future<void> Function(_CallFixture) run) {
  testWidgets(name, (tester) async {
    final fixture = _CallFixture(tester);
    try {
      final connecting = fixture.avatar.connect(
        Uri.parse('http://voice.invalid'),
        'fixture',
      );
      await fixture.pump(Duration.zero);
      expect(fixture.avatar.link, AvatarLink.connected);
      await connecting;
      final dialing = fixture.avatar.startCall();
      await fixture.pump(Duration.zero);
      expect(
        fixture.backend.offers,
        hasLength(1),
        reason: '${fixture.avatar.link}: ${fixture.avatar.notice}',
      );
      await dialing;
      await fixture.ready();
      expect(fixture.avatar.link, AvatarLink.inCall);
      await run(fixture);
    } finally {
      fixture.avatar.dispose();
      await fixture.pump(Duration.zero);
    }
  });
}

class _CallFixture {
  _CallFixture(this.tester) {
    _mockChannel(
      'vox/avatar/audio',
      (call) => call.method == 'requestMicrophone' ? true : null,
    );
    _mockChannel('vox/avatar/audio-events', (_) => null);
    _mockChannel('FlutterWebRTC.Event', (_) => null);
    _mockChannel('FlutterWebRTC.Method', _rtcMethod);
  }

  final WidgetTester tester;
  final backend = _VoiceBackend();
  final _messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  late final avatar = AvatarConversation(
    createServer: (uri, token) => AvatarServer(uri, token, adapter: backend),
  );
  int _peer = 0;

  static const _sdp = {'sdp': 'v=0\r\na=candidate:test', 'type': 'offer'};
  static const _track = {
    'id': 'audio',
    'label': 'audio',
    'kind': 'audio',
    'enabled': true,
  };
  static const _rtp = {
    'codecs': [],
    'encodings': [],
    'headerExtensions': [],
    'rtcp': {'reducedSize': false},
  };

  String get _peerEvents => 'FlutterWebRTC/peerConnectionEvent$_peer';

  Object? _rtcMethod(MethodCall call) {
    if (call.method == 'createPeerConnection') {
      _peer++;
      _mockChannel(_peerEvents, (_) => null);
      _mockChannel(
        'FlutterWebRTC/dataChannelEvent${_peer}channel',
        (_) => null,
      );
      return {'peerConnectionId': '$_peer'};
    }
    return switch (call.method) {
      'getUserMedia' => {
        'streamId': 'microphone',
        'audioTracks': [_track],
      },
      'addTrack' => {
        'senderId': 'sender',
        'track': _track,
        'rtpParameters': _rtp,
        'ownsTrack': false,
      },
      'createDataChannel' => {'id': 0, 'flutterId': 'channel'},
      'createOffer' || 'getLocalDescription' => _sdp,
      'getIceGatheringState' => {'state': 'complete'},
      'getStats' => {'stats': []},
      _ => null,
    };
  }

  void _mockChannel(String name, Object? Function(MethodCall) handler) {
    _messenger.setMockMethodCallHandler(
      MethodChannel(name),
      (call) async => handler(call),
    );
  }

  Future<void> ready() async {
    backend.send('data: {"type":"ready"}\n\n');
    await _peerEvent({
      'event': 'onTrack',
      'streams': [],
      'track': _track,
      'receiver': {
        'receiverId': 'receiver',
        'track': _track,
        'rtpParameters': _rtp,
      },
    });
    await connectionState('connected');
  }

  Future<void> connectionState(String state) =>
      _peerEvent({'event': 'peerConnectionState', 'state': state});

  Future<void> _peerEvent(Map<String, Object> event) async {
    final delivered = _messenger.handlePlatformMessage(
      _peerEvents,
      const StandardMethodCodec().encodeSuccessEnvelope(event),
      null,
    );
    await pump(Duration.zero);
    await delivered;
  }

  Future<void> pump(Duration elapsed) async {
    await tester.pump(elapsed);
    // WebRTC's channel and peer subscriptions finish cancelling in the real
    // event loop. Drain those completions before advancing the fake clock.
    for (var pass = 0; pass < 3; pass++) {
      await tester.runAsync(() => Future<void>.delayed(Duration.zero));
      await tester.pump(Duration.zero);
    }
  }
}

class _VoiceBackend implements HttpClientAdapter {
  final offers = <String>[];
  final deletes = <String>[];
  final offerErrors = <int>[];
  final _streams = <String, StreamController<Uint8List>>{};
  bool stallNextDelete = false;
  Completer<void>? holdNextOffer;
  String? _activeSession;

  void send(String line) {
    _streams[offers.last]!.add(Uint8List.fromList(utf8.encode(line)));
  }

  Future<void> endEvents() => _streams[offers.last]!.close();

  @override
  Future<ResponseBody> fetch(
    RequestOptions request,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    final path = request.uri.pathSegments;
    if (path.last == 'settings') {
      return _json(200, {'hasApiKey': true, 'cards': []});
    }
    if (request.method == 'POST') {
      final body = jsonDecode(request.data as String) as Map<String, dynamic>;
      final id = body['id'] as String;
      offers.add(id);
      final hold = holdNextOffer;
      holdNextOffer = null;
      if (hold != null) {
        await Future.any([hold.future, cancelFuture!]);
        if (request.cancelToken!.isCancelled) {
          throw request.cancelToken!.cancelError!;
        }
      }
      if (offerErrors.isNotEmpty) return _json(offerErrors.removeAt(0), {});
      if (_activeSession != null) return _json(409, {});
      _activeSession = id;
      return _json(200, {'sdp': 'v=0'});
    }
    if (request.method == 'DELETE') {
      final id = path.last;
      deletes.add(id);
      if (stallNextDelete) {
        stallNextDelete = false;
        await cancelFuture;
        throw request.cancelToken!.cancelError!;
      }
      if (_activeSession == id) _activeSession = null;
      return ResponseBody.fromString('', 204);
    }
    final stream = _streams[path[path.length - 2]] =
        StreamController<Uint8List>();
    return ResponseBody(
      stream.stream,
      200,
      headers: {
        Headers.contentTypeHeader: ['text/event-stream'],
      },
    );
  }

  ResponseBody _json(int status, Map<String, Object> data) =>
      ResponseBody.fromString(
        jsonEncode(data),
        status,
        headers: {
          Headers.contentTypeHeader: [Headers.jsonContentType],
        },
      );

  @override
  void close({bool force = false}) {
    for (final stream in _streams.values) {
      if (!stream.isClosed) unawaited(stream.close());
    }
  }
}
