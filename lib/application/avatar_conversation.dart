import 'dart:async';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../infrastructure/avatar_server.dart';
import 'avatar_call.dart';
import 'avatar_defaults.dart';

export '../infrastructure/avatar_server.dart' show AvatarCard;

enum AvatarPhase { idle, listening, thinking, speaking }

enum AvatarLink { local, checking, connected, calling, inCall, reconnecting }

class AvatarConversation extends ChangeNotifier {
  AvatarConversation({this._createServer = AvatarServer.new}) {
    _audioEvents = _events.receiveBroadcastStream().listen(
      _onAudio,
      onError: (Object error) {
        if (link == AvatarLink.local && phase != AvatarPhase.idle) {
          unawaited(stopLocal(message: '音声を利用できませんでした。'));
        }
      },
    );
  }

  static const _methods = MethodChannel('vox/avatar/audio');
  static const _events = EventChannel('vox/avatar/audio-events');
  static const _bytesPerSecond = 24000 * 2;
  static const _maxRecordingSeconds = 20;
  static const _maxCaptureBytes = _bytesPerSecond * _maxRecordingSeconds;
  static const _sampleCaption = 'こんにちは。今日は、どんなお話をしましょうか？';
  static const _missingApiKey = 'PC 側で OpenAI API キーを設定し、通話開始ボタンを押してください。';

  final level = ValueNotifier<double>(0);
  final AvatarServer Function(Uri, String) _createServer;
  late final StreamSubscription<Object?> _audioEvents;
  final _recording = BytesBuilder(copy: false);
  AvatarServer? _server;
  AvatarCall? _call;
  Future<void>? _callCleanup;
  CancelToken? _check;
  Timer? _recordingLimit;
  int _localGeneration = 0;
  bool _closed = false;
  int _quietSamples = 0;

  AvatarPhase phase = AvatarPhase.idle;
  AvatarLink link = AvatarLink.local;
  String endpoint = defaultAvatarEndpoint;
  String _token = defaultAvatarToken;
  String get token => _token;
  String caption = '';
  String? notice;
  bool busy = false;
  bool hasApiKey = false;
  List<AvatarCard> cards = const [];
  String card = 'none';

  static Uri? parseEndpoint(String input) {
    final text = input.trim();
    if (text.isEmpty) return null;
    final hasScheme = text.contains('://');
    final uri = Uri.tryParse(hasScheme ? text : 'http://$text');
    if (uri == null ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty ||
        uri.authority.contains('@') ||
        uri.hasQuery ||
        uri.hasFragment ||
        (uri.path.isNotEmpty && uri.path != '/') ||
        (uri.hasPort && (uri.port < 1 || uri.port > 65535))) {
      return null;
    }
    final withPort = !hasScheme && !RegExp(r':\d+/?$').hasMatch(text)
        ? uri.replace(port: 4192)
        : uri;
    return withPort.replace(path: '');
  }

  Future<void> connect(Uri uri, String token) async {
    if (_closed || busy || _call != null || phase != AvatarPhase.idle) return;
    final server = _createServer(uri, token);
    final cancel = CancelToken();
    _clearServer();
    _server = server;
    _check = cancel;
    if (endpoint != uri.toString()) card = 'none';
    endpoint = uri.toString();
    _token = token;
    caption = '';
    notice = null;
    link = AvatarLink.checking;
    _notify();
    try {
      final settings = await server.settings(cancel);
      if (!identical(_server, server)) return;
      _applySettings(settings);
      link = AvatarLink.connected;
      _notify();
    } on AvatarServerException catch (error) {
      if (identical(_server, server)) {
        _clearServer();
        _show(error.displayMessage);
      }
    } catch (_) {
      if (identical(_server, server)) {
        _clearServer();
        _show('サーバーの設定を読み取れませんでした。');
      }
    } finally {
      if (identical(_check, cancel)) _check = null;
    }
  }

  void _applySettings(AvatarServerSettings settings) {
    cards = settings.cards;
    hasApiKey = settings.hasApiKey;
    if (!cards.any((item) => item.id == card)) card = 'none';
    if (!hasApiKey) notice = _missingApiKey;
  }

  void selectCard(String id) {
    if (link != AvatarLink.connected) return;
    card = id;
    _notify();
  }

  Future<void> startCall() async {
    final server = _server;
    if (_closed || server == null || link != AvatarLink.connected || busy) {
      return;
    }
    late final AvatarCall call;
    call = AvatarCall(
      server,
      onReady: () {
        if (!identical(_call, call)) return;
        link = AvatarLink.inCall;
        phase = AvatarPhase.listening;
        _notify();
      },
      onReconnecting: () {
        if (!identical(_call, call) || link == AvatarLink.reconnecting) return;
        link = AvatarLink.reconnecting;
        phase = AvatarPhase.idle;
        _quietSamples = 0;
        level.value = 0;
        _notify();
      },
      onClosed: (message) {
        if (identical(_call, call)) unawaited(hangUp(message: message));
      },
      onAudio: (rms) {
        if (identical(_call, call)) _onRemoteAudio(rms);
      },
    );
    _call = call;
    _quietSamples = 0;
    link = AvatarLink.calling;
    caption = '';
    notice = null;
    phase = AvatarPhase.thinking;
    _notify();
    try {
      // Hanging up releases the UI immediately. A new call waits for the old
      // offer and cleanup before claiming the server's call slot.
      await _callCleanup;
      if (!identical(_call, call)) return;
      final cancel = CancelToken();
      _check = cancel;
      try {
        final settings = await server.settings(cancel);
        if (!identical(_call, call)) return;
        _applySettings(settings);
      } finally {
        if (identical(_check, cancel)) _check = null;
      }
      if (!identical(_call, call)) return;
      if (!hasApiKey) {
        await hangUp(message: notice);
        return;
      }
      final granted = await _methods.invokeMethod<bool>('requestMicrophone');
      if (!identical(_call, call)) return;
      if (granted != true) {
        await hangUp(message: 'Android の設定でマイクの使用を許可してください。');
        return;
      }
      await call.start(card);
    } on AvatarServerException catch (error) {
      if (identical(_call, call)) {
        await hangUp(message: error.displayMessage);
      }
    } catch (_) {
      if (identical(_call, call)) {
        await hangUp(message: 'マイクまたは音声接続を開始できませんでした。');
      }
    }
  }

  void _onRemoteAudio(double rms) {
    if (_closed || link != AvatarLink.inCall) return;
    final target = ((rms - 0.007) * 10).clamp(0.0, 1.0);
    final current = level.value;
    level.value =
        current + (target - current) * (target > current ? 0.8 : 0.55);
    if (target > 0.04) {
      _quietSamples = 0;
      if (phase != AvatarPhase.speaking) {
        phase = AvatarPhase.speaking;
        _notify();
      }
    } else if (phase == AvatarPhase.speaking && ++_quietSamples >= 5) {
      level.value = 0;
      phase = AvatarPhase.listening;
      _notify();
    }
  }

  Future<void> hangUp({String? message}) async {
    final call = _call;
    if (call == null) return;
    _call = null;
    _check?.cancel();
    _check = null;
    _releaseCall(call);
    phase = AvatarPhase.idle;
    level.value = 0;
    notice = message;
    if (_server != null && !hasApiKey) notice ??= _missingApiKey;
    link = _server == null ? AvatarLink.local : AvatarLink.connected;
    _notify();
  }

  void _releaseCall(AvatarCall call) {
    final previous = _callCleanup;
    final closing = call.close();
    final cleanup = previous == null
        ? closing
        : Future.wait([previous, closing]).then<void>((_) {});
    _callCleanup = cleanup;
    unawaited(
      cleanup.whenComplete(() {
        if (identical(_callCleanup, cleanup)) _callCleanup = null;
      }),
    );
  }

  void disconnectServer() {
    if (_call != null || busy) return;
    _clearServer();
    _show(null);
  }

  void _clearServer() {
    _check?.cancel();
    _check = null;
    final server = _server;
    if (server != null) _closeServer(server);
    _server = null;
    cards = const [];
    hasApiKey = false;
    link = AvatarLink.local;
  }

  void _closeServer(AvatarServer server) {
    final pending = _callCleanup;
    if (pending == null) {
      server.close();
    } else {
      unawaited(pending.whenComplete(server.close));
    }
  }

  Future<void> stopActivity() async {
    if (_call != null) {
      await hangUp();
    } else if (link == AvatarLink.checking) {
      disconnectServer();
    } else if (link == AvatarLink.local) {
      await stopLocal();
    }
  }

  Future<void> startRecording() async {
    if (busy || phase != AvatarPhase.idle || link != AvatarLink.local) return;
    final generation = _localGeneration;
    busy = true;
    caption = '';
    notice = null;
    _notify();
    try {
      final granted = await _methods.invokeMethod<bool>('requestMicrophone');
      if (!_isCurrent(generation)) return;
      if (granted != true) {
        _show('Android の設定でマイクの使用を許可してください。');
        return;
      }
      _recording.clear();
      phase = AvatarPhase.listening;
      await _methods.invokeMethod<void>('startRecording');
      if (!_isCurrent(generation)) return;
      _recordingLimit = Timer(
        const Duration(seconds: _maxRecordingSeconds),
        () => unawaited(finishRecording()),
      );
    } catch (_) {
      if (_isCurrent(generation)) {
        await stopLocal(message: 'マイクを起動できませんでした。');
      }
    } finally {
      _finishLocalOperation(generation);
    }
  }

  Future<void> finishRecording() async {
    if (busy || phase != AvatarPhase.listening || link != AvatarLink.local) {
      return;
    }
    _recordingLimit?.cancel();
    final generation = _localGeneration;
    busy = true;
    _notify();
    try {
      await _methods.invokeMethod<void>('stopRecording');
      if (!_isCurrent(generation)) return;
      final audio = _recording.takeBytes();
      if (audio.length < _bytesPerSecond ~/ 5) {
        phase = AvatarPhase.idle;
        _show('もう少し長く話してみてください。');
        return;
      }
      await _playLocal(audio, generation);
    } catch (_) {
      if (_isCurrent(generation)) {
        await stopLocal(message: '録音を再生できませんでした。');
      }
    } finally {
      _finishLocalOperation(generation);
    }
  }

  Future<void> playSample() async {
    if (busy || phase != AvatarPhase.idle || link != AvatarLink.local) return;
    final generation = _localGeneration;
    busy = true;
    notice = null;
    caption = _sampleCaption;
    _notify();
    try {
      final sample = await rootBundle.load('assets/avatar/preview.pcm');
      if (_isCurrent(generation)) {
        await _playLocal(
          sample.buffer.asUint8List(sample.offsetInBytes, sample.lengthInBytes),
          generation,
        );
      }
    } catch (_) {
      if (_isCurrent(generation)) {
        await stopLocal(message: 'サンプル音声を再生できませんでした。');
      }
    } finally {
      _finishLocalOperation(generation);
    }
  }

  Future<void> _playLocal(Uint8List audio, int generation) async {
    phase = AvatarPhase.thinking;
    _notify();
    await _methods.invokeMethod<void>('startPlayback');
    if (!_isCurrent(generation)) return;
    await _methods.invokeMethod<void>('writePlayback', audio);
    if (!_isCurrent(generation)) return;
    await _methods.invokeMethod<void>('finishPlayback');
  }

  void _onAudio(Object? event) {
    if (_closed || link != AvatarLink.local) return;
    if (event is Uint8List && phase == AvatarPhase.listening) {
      final remaining = _maxCaptureBytes - _recording.length;
      if (remaining == 0) return;
      _recording.add(
        event.length <= remaining
            ? event
            : Uint8List.sublistView(event, 0, remaining),
      );
      if (_recording.length == _maxCaptureBytes) unawaited(finishRecording());
    } else if (event is Map) {
      switch (event['type']) {
        case 'playing' when phase == AvatarPhase.thinking:
          phase = AvatarPhase.speaking;
          _notify();
        case 'level' when phase == AvatarPhase.speaking:
          level.value = (event['value'] as num).toDouble();
        case 'drained' when phase == AvatarPhase.speaking:
          phase = AvatarPhase.idle;
          level.value = 0;
          _notify();
        case 'error' when phase != AvatarPhase.idle:
          final message = switch (event['code']) {
            'captureFailed' => '録音が中断されました。',
            'playbackInterrupted' => '音声再生が中断されました。',
            _ => '音声を再生できませんでした。',
          };
          unawaited(stopLocal(message: message));
      }
    }
  }

  Future<void> stopLocal({String? message}) async {
    if (_closed || link != AvatarLink.local) return;
    final generation = ++_localGeneration;
    _resetLocal();
    notice = message;
    busy = true;
    _notify();
    await _stopNativeAudio();
    _finishLocalOperation(generation);
  }

  void _resetLocal() {
    _recordingLimit?.cancel();
    _recording.clear();
    phase = AvatarPhase.idle;
    caption = '';
    level.value = 0;
  }

  Future<void> _stopNativeAudio() async {
    try {
      await _methods.invokeMethod<void>('stop');
    } on PlatformException {
      // A detach can close the platform channel during cleanup.
    } on MissingPluginException {
      // The activity is no longer attached.
    }
  }

  void _finishLocalOperation(int generation) {
    if (_isCurrent(generation)) {
      busy = false;
      _notify();
    }
  }

  void _show(String? message) {
    notice = message;
    _notify();
  }

  bool _isCurrent(int generation) =>
      !_closed && link == AvatarLink.local && _localGeneration == generation;

  void _notify() {
    if (!_closed) notifyListeners();
  }

  @override
  void dispose() {
    _closed = true;
    _check?.cancel();
    final call = _call;
    _call = null;
    final server = _server;
    _server = null;
    if (call != null) _releaseCall(call);
    if (server != null) _closeServer(server);
    _resetLocal();
    unawaited(_stopNativeAudio());
    unawaited(_audioEvents.cancel());
    level.dispose();
    super.dispose();
  }
}
