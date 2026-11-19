import 'dart:async';
import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:uuid/uuid.dart';

import '../infrastructure/avatar_server.dart';

class AvatarCall {
  AvatarCall(
    this._server, {
    required this.onReady,
    required this.onReconnecting,
    required this.onClosed,
    required this.onAudio,
  });

  static const _retryDelays = [Duration(seconds: 1), Duration(seconds: 3)];
  static const _reconnectFailed =
      '再接続できませんでした。ネットワークと PC 側の音声サービスを確認して、もう一度お試しください。';

  final AvatarServer _server;
  final void Function() onReady;
  final void Function() onReconnecting;
  final void Function(String message) onClosed;
  final void Function(double level) onAudio;

  _AvatarSession? _session;
  Timer? _retryTimer;
  Timer? _recoveryTimer;
  Timer? _stableTimer;
  int _retryCount = 0;
  bool _hasConnected = false;
  bool _closed = false;

  Future<void> start(String card) async {
    if (_closed) return;
    late final _AvatarSession session;
    session = _AvatarSession(
      _server,
      onReady: _onReady,
      onInterrupted: () {
        _stableTimer?.cancel();
        onReconnecting();
      },
      onClosed: (message, retryable) =>
          unawaited(_onSessionClosed(session, card, message, retryable)),
      onAudio: onAudio,
    );
    _session = session;
    try {
      await session.start(card);
    } on AvatarServerException catch (error) {
      session._reportClosed(error.displayMessage, retryable: error.retryable);
    } on TimeoutException {
      session._reportClosed('音声接続の準備がタイムアウトしました。');
    } catch (_) {
      session._reportClosed('マイクまたは音声接続を開始できませんでした。', retryable: false);
    }
  }

  void _onReady() {
    _hasConnected = true;
    _recoveryTimer?.cancel();
    _recoveryTimer = null;
    if (_retryCount > 0) {
      _stableTimer = Timer(const Duration(seconds: 15), () => _retryCount = 0);
    }
    onReady();
  }

  Future<void> _onSessionClosed(
    _AvatarSession session,
    String card,
    String message,
    bool retryable,
  ) async {
    if (_closed) return;
    _stableTimer?.cancel();
    if (!_hasConnected || !retryable) {
      _finish(message);
      return;
    }
    if (_retryCount == _retryDelays.length) {
      _finish(_reconnectFailed);
      return;
    }
    _recoveryTimer ??= Timer(
      const Duration(seconds: 60),
      () => _finish(_reconnectFailed),
    );
    onReconnecting();
    await session.close();
    if (_closed) return;
    _retryTimer = Timer(_retryDelays[_retryCount++], () {
      unawaited(start(card));
    });
  }

  void _finish(String message) {
    unawaited(close());
    onClosed(message);
  }

  Future<void> close() {
    _closed = true;
    _retryTimer?.cancel();
    _recoveryTimer?.cancel();
    _stableTimer?.cancel();
    return _session?.close() ?? Future<void>.value();
  }
}

class _AvatarSession {
  _AvatarSession(
    this._server, {
    required this.onReady,
    required this.onInterrupted,
    required this.onClosed,
    required this.onAudio,
  });

  final AvatarServer _server;
  final void Function() onReady;
  final void Function() onInterrupted;
  final void Function(String message, bool retryable) onClosed;
  final void Function(double level) onAudio;

  final _id = const Uuid().v4();
  final _requests = CancelToken();
  final _iceComplete = Completer<void>();
  RTCPeerConnection? _peer;
  MediaStream? _microphone;
  RTCDataChannel? _channel;
  StreamSubscription<({String type, String? message})>? _events;
  Future<void>? _pendingRelease;
  Future<String>? _offerRequest;
  Future<void>? _closing;
  Timer? _connectionTimer;
  Timer? _disconnectTimer;
  Timer? _statsTimer;
  bool _closed = false;
  bool _reportedClosed = false;
  bool _serverReady = false;
  bool _mediaReady = false;
  bool _ready = false;
  bool _readingStats = false;
  bool _hasRemoteAudio = false;
  String? _audioReportId;
  double? _previousEnergy;
  double? _previousDuration;

  Future<void> start(String card) async {
    final release = _pendingRelease = _server.retryPendingEnd();
    await release;
    if (_closed) return;
    final peer = await createPeerConnection({
      'iceServers': <Object>[],
      'sdpSemantics': 'unified-plan',
    });
    if (_closed) {
      await _release(peer.dispose);
      return;
    }
    _peer = peer;
    peer.onIceGatheringState = (state) {
      if (state == RTCIceGatheringState.RTCIceGatheringStateComplete &&
          !_iceComplete.isCompleted) {
        _iceComplete.complete();
      }
    };
    peer.onConnectionState = _onConnectionState;
    peer.onTrack = (event) {
      if (_closed || event.track.kind != 'audio') return;
      // libwebrtc plays the incoming audio track directly on Android.
      _hasRemoteAudio = true;
      _updateReady();
    };

    final microphone = await navigator.mediaDevices.getUserMedia({
      'audio': {'echoCancellation': true, 'noiseSuppression': true},
      'video': false,
    });
    if (_closed) {
      await _release(microphone.dispose);
      return;
    }
    _microphone = microphone;
    final tracks = microphone.getAudioTracks();
    if (tracks.isEmpty) throw const FormatException('Missing microphone track');
    await peer.addTrack(tracks.first, microphone);
    if (_closed) return;

    final channel = await peer.createDataChannel(
      'oai-events',
      RTCDataChannelInit(),
    );
    if (_closed) {
      await _release(channel.close);
      return;
    }
    _channel = channel;
    final offer = await peer.createOffer({
      'offerToReceiveAudio': true,
      'offerToReceiveVideo': false,
    });
    if (_closed) return;
    await peer.setLocalDescription(offer);
    if (_closed) return;
    if (await peer.getIceGatheringState() !=
        RTCIceGatheringState.RTCIceGatheringStateComplete) {
      await _iceComplete.future.timeout(const Duration(seconds: 10));
    }
    if (_closed) return;
    final local = await peer.getLocalDescription();
    if (_closed) return;
    final sdp = local?.sdp;
    if (sdp == null || !sdp.contains('a=candidate:')) {
      throw const FormatException('Missing local ICE candidates');
    }

    final request = _server.createSession(
      _id,
      sdp,
      card: card,
      cancel: _requests,
    );
    _offerRequest = request;
    final answer = await request;
    if (_closed) return;

    _connectionTimer = Timer(const Duration(seconds: 20), () {
      _reportClosed('音声接続を確立できませんでした。接続先を確認してください。');
    });
    // Subscribe immediately. The server waits up to ten seconds for this stream.
    _events = _server
        .events(_id, _requests)
        .listen(
          (event) {
            if (_closed) return;
            if (event.type == 'ready') {
              _serverReady = true;
              _updateReady();
            } else if (event.type == 'closed') {
              // The LAN API also sends closed when the PC loses upstream audio.
              _reportClosed(event.message ?? 'サーバーが通話を終了しました。');
            }
          },
          onError: _onEventError,
          onDone: () => _reportClosed('サーバーとの通話が切断されました。'),
        );
    await peer.setRemoteDescription(RTCSessionDescription(answer, 'answer'));
    if (!_closed) await Helper.setSpeakerphoneOnButPreferBluetooth();
  }

  void _onEventError(Object error) {
    switch (error) {
      case AvatarServerException():
        _reportClosed(
          error.displayMessage,
          retryable: error.retryable || error.status == 404,
        );
      case DioException(type: DioExceptionType.receiveTimeout):
        _reportClosed('サーバーから通話状態が届かなくなりました。');
      case FormatException():
        _reportClosed('サーバーの通話状態を読み取れませんでした。', retryable: false);
      default:
        _reportClosed('サーバーとの通話が切断されました。');
    }
  }

  void _onConnectionState(RTCPeerConnectionState state) {
    if (_closed) return;
    switch (state) {
      case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
        _disconnectTimer?.cancel();
        _disconnectTimer = null;
        _mediaReady = true;
        _updateReady();
      case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
        final wasReady = _ready;
        _mediaReady = false;
        _ready = false;
        _disconnectTimer ??= Timer(const Duration(seconds: 4), () {
          _reportClosed('音声接続が切断されました。');
        });
        if (wasReady) onInterrupted();
      case RTCPeerConnectionState.RTCPeerConnectionStateFailed ||
          RTCPeerConnectionState.RTCPeerConnectionStateClosed:
        _reportClosed('音声接続が切断されました。');
      default:
        break;
    }
  }

  void _updateReady() {
    if (_ready || !_serverReady || !_mediaReady || !_hasRemoteAudio) {
      return;
    }
    _ready = true;
    _connectionTimer?.cancel();
    _statsTimer ??= Timer.periodic(const Duration(milliseconds: 75), (_) {
      if (_ready && !_readingStats) unawaited(_readAudioLevel());
    });
    onReady();
  }

  Future<void> _readAudioLevel() async {
    final peer = _peer;
    if (peer == null || _closed) return;
    _readingStats = true;
    try {
      final reports = await peer.getStats().timeout(const Duration(seconds: 2));
      if (_closed || !_ready) return;
      for (final report in reports) {
        final values = report.values;
        if (report.type != 'inbound-rtp' ||
            (values['kind'] ?? values['mediaType']) != 'audio') {
          continue;
        }
        final energy = (values['totalAudioEnergy'] as num?)?.toDouble();
        final duration = (values['totalSamplesDuration'] as num?)?.toDouble();
        var rms = (values['audioLevel'] as num?)?.toDouble() ?? 0;
        if (_audioReportId == report.id &&
            energy != null &&
            duration != null &&
            _previousEnergy != null &&
            _previousDuration != null) {
          final time = duration - _previousDuration!;
          final power = energy - _previousEnergy!;
          rms = time > 0 && power >= 0 ? math.sqrt(power / time) : 0;
        }
        _audioReportId = report.id;
        _previousEnergy = energy;
        _previousDuration = duration;
        onAudio(rms.isFinite ? rms.clamp(0.0, 1.0) : 0);
        return;
      }
      onAudio(0);
    } catch (_) {
      if (!_closed && _ready) onAudio(0);
    } finally {
      _readingStats = false;
    }
  }

  void _reportClosed(String message, {bool retryable = true}) {
    if (_closed || _reportedClosed) return;
    _reportedClosed = true;
    onClosed(message, retryable);
  }

  Future<void> close() => _closing ??= _close();

  Future<void> _close() async {
    _closed = true;
    _connectionTimer?.cancel();
    _disconnectTimer?.cancel();
    _statsTimer?.cancel();
    if (!_iceComplete.isCompleted) _iceComplete.complete();

    final stream = _events;
    final peer = _peer;
    final channel = _channel;
    final microphone = _microphone;
    final pendingRelease = _pendingRelease;
    final request = _offerRequest;
    // If hangup races with POST, delete the session after the server answers.
    // Release local resources immediately while that request settles.
    if (stream != null || request == null) _requests.cancel();
    await Future.wait([
      if (stream != null) _release(stream.cancel),
      if (peer != null || channel != null || microphone != null)
        _releaseMedia(peer, channel, microphone),
      if (pendingRelease != null) _release(() => pendingRelease),
      if (request != null) _endServerSession(request),
    ]);
  }

  Future<void> _releaseMedia(
    RTCPeerConnection? peer,
    RTCDataChannel? channel,
    MediaStream? microphone,
  ) async {
    if (microphone != null) await _release(microphone.dispose);
    if (channel != null) await _release(channel.close);
    if (peer != null) {
      await _release(peer.close);
      await _release(peer.dispose);
    }
  }

  Future<void> _endServerSession(Future<String> request) async {
    try {
      await request;
    } on AvatarServerException catch (error) {
      // An explicit HTTP refusal did not acquire the server's call slot.
      if (error.status
          case 400 || 401 || 403 || 404 || 409 || 413 || 415 || 429) {
        return;
      }
    } catch (_) {
      // The server may have accepted an offer whose response was lost.
    }
    await _release(() => _server.endSession(_id));
  }

  Future<void> _release(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      // Attempt the remaining cleanup if a device or the server has vanished.
    }
  }
}
