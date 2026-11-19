import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live2d_flutter/flutter_live2d.dart';

import '../../application/avatar_conversation.dart';
import '../../application/providers.dart';
import '../routes.dart';
import 'avatar_settings_screen.dart';

const _paper = Color(0xFFF4F2E9);
const _ink = Color(0xFF1C3029);
const _muted = Color(0xFF4D6358);
const _mint = Color(0xFFDAEF9D);
const _stage = Color(0xFF1A352C);

class AvatarScreen extends ConsumerStatefulWidget {
  const AvatarScreen({super.key});

  @override
  ConsumerState<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends ConsumerState<AvatarScreen>
    with WidgetsBindingObserver {
  static const _avatarSetting = 'avatar.character';

  late final AvatarConversation _conversation;
  AvatarCharacter _character = AvatarCharacter.hiyori;

  @override
  void initState() {
    super.initState();
    _conversation = AvatarConversation();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_restoreCharacter());
  }

  Future<void> _restoreCharacter() async {
    try {
      final saved = await ref
          .read(runtimeProvider)
          .store
          .setting(_avatarSetting);
      if (mounted && saved == AvatarCharacter.wanko.name) {
        setState(() => _character = AvatarCharacter.wanko);
      }
    } catch (_) {
      // Keep the default avatar if the saved preference cannot be read.
    }
  }

  Future<void> _openAvatarSettings(BuildContext context) async {
    final theme = Theme.of(context);
    final next = await Navigator.of(context).push<AvatarCharacter>(
      MaterialPageRoute(
        builder: (_) => Theme(
          data: theme,
          child: AvatarSettingsScreen(selected: _character),
        ),
      ),
    );
    if (!mounted || next == null || next == _character) return;
    setState(() => _character = next);
    try {
      await ref
          .read(runtimeProvider)
          .store
          .saveSetting(_avatarSetting, next.name);
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('アバターの選択を保存できませんでした。')));
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.hidden) {
      unawaited(_conversation.stopActivity());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _conversation.dispose();
    super.dispose();
  }

  Future<void> _openVoxLocal() async {
    await _conversation.stopActivity();
    if (!mounted) return;
    ref.read(runtimeProvider).warmInstalledModel();
    const WorkspaceRoute().go(context);
  }

  Future<void> _openServerSettings() async {
    final settings = await showDialog<({Uri uri, String token})>(
      context: context,
      builder: (context) => _ServerDialog(
        endpoint: _conversation.endpoint,
        token: _conversation.token,
        onDisconnect: _conversation.link == AvatarLink.connected
            ? _conversation.disconnectServer
            : null,
      ),
    );
    if (mounted && settings != null) {
      await _conversation.connect(settings.uri, settings.token);
    }
  }

  @override
  Widget build(BuildContext context) {
    final legacyRecording = ref.watch(
      sessionProvider.select((state) => state.active),
    );
    final scheme = ColorScheme.fromSeed(seedColor: _ink).copyWith(
      primary: _ink,
      onPrimary: Colors.white,
      primaryContainer: _mint,
      onPrimaryContainer: _ink,
      surface: _paper,
      onSurface: _ink,
      onSurfaceVariant: _muted,
    );
    return Theme(
      data: ThemeData(useMaterial3: true, colorScheme: scheme),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: Scaffold(
          backgroundColor: _paper,
          body: SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 900),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ListenableBuilder(
                    listenable: _conversation,
                    builder: (context, _) {
                      final avatar = _conversation;
                      final ready = !avatar.busy && !legacyRecording;
                      return Column(
                        children: [
                          _Header(
                            onConnection: !ready
                                ? null
                                : switch (avatar.link) {
                                    AvatarLink.checking =>
                                      avatar.disconnectServer,
                                    AvatarLink.local || AvatarLink.connected =>
                                      avatar.phase == AvatarPhase.idle
                                          ? _openServerSettings
                                          : null,
                                    _ => null,
                                  },
                            onVoxLocal: avatar.busy ? null : _openVoxLocal,
                            link: avatar.link,
                          ),
                          const SizedBox(height: 6),
                          Expanded(
                            child: LayoutBuilder(
                              builder: (context, size) {
                                final scene = _Stage(
                                  character: _character,
                                  phase: avatar.phase,
                                  level: avatar.level,
                                  caption: avatar.caption,
                                  onSettings: () =>
                                      _openAvatarSettings(context),
                                );
                                final controls = _Controls(
                                  avatar: avatar,
                                  ready: ready,
                                  legacyRecording: legacyRecording,
                                );
                                if (size.maxWidth >= 620) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Expanded(flex: 3, child: scene),
                                      const SizedBox(width: 28),
                                      Expanded(
                                        flex: 2,
                                        child: Center(
                                          child: SingleChildScrollView(
                                            child: controls,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                                return Column(
                                  children: [
                                    Expanded(child: scene),
                                    controls,
                                  ],
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.onConnection,
    required this.onVoxLocal,
    required this.link,
  });

  final VoidCallback? onConnection;
  final VoidCallback? onVoxLocal;
  final AvatarLink link;

  @override
  Widget build(BuildContext context) {
    final (icon, label) = switch (link) {
      AvatarLink.local => (Icons.wifi_rounded, 'サーバーに接続'),
      AvatarLink.checking => (Icons.close_rounded, '確認中'),
      AvatarLink.connected => (Icons.link_rounded, 'サーバー確認済み'),
      AvatarLink.calling => (Icons.link_rounded, '通話準備中'),
      AvatarLink.inCall => (Icons.link_rounded, '通話中'),
      AvatarLink.reconnecting => (Icons.sync_rounded, '再接続中'),
    };
    return SizedBox(
      height: 62,
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Vox Live',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: _ink,
                fontSize: 25,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.85,
              ),
            ),
          ),
          Tooltip(
            message: link == AvatarLink.checking
                ? '接続確認をキャンセル'
                : link == AvatarLink.connected
                ? 'サーバー接続設定'
                : label,
            child: TextButton.icon(
              onPressed: onConnection,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 9),
                foregroundColor: _ink,
                disabledForegroundColor: _muted,
              ),
              icon: Icon(icon, size: 19),
              label: Text(label, style: const TextStyle(fontSize: 12)),
            ),
          ),
          IconButton(
            tooltip: 'Vox Local の録音ライブラリ',
            onPressed: onVoxLocal,
            icon: const Icon(
              Icons.library_books_outlined,
              color: _ink,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stage extends StatelessWidget {
  const _Stage({
    required this.character,
    required this.phase,
    required this.level,
    required this.caption,
    required this.onSettings,
  });

  final AvatarCharacter character;
  final AvatarPhase phase;
  final ValueListenable<double> level;
  final String caption;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final light = switch (phase) {
      AvatarPhase.idle => const Color(0xFF53745C),
      AvatarPhase.listening => const Color(0xFF648557),
      AvatarPhase.thinking => const Color(0xFF4F6868),
      AvatarPhase.speaking => const Color(0xFF71934E),
    };
    return ClipRRect(
      borderRadius: BorderRadius.circular(26),
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0, -0.22),
                radius: 0.88,
                colors: [light, _stage, const Color(0xFF152822)],
                stops: const [0, 0.64, 1],
              ),
            ),
          ),
          const CustomPaint(painter: _StageRings()),
          _AvatarModel(
            key: ValueKey(character),
            character: character,
            phase: phase,
            level: level,
          ),
          Positioned(
            top: 19,
            left: 20,
            right: 64,
            child: IgnorePointer(
              child: Text(
                character.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  shadows: [Shadow(color: _stage, blurRadius: 8)],
                ),
              ),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              tooltip: 'アバター設定',
              onPressed: onSettings,
              color: Colors.white,
              icon: const Icon(Icons.settings_outlined),
            ),
          ),
          if (caption.isNotEmpty)
            Positioned(
              bottom: 18,
              left: 16,
              right: 16,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xED13261E),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 11,
                    ),
                    child: Text(
                      caption,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        height: 1.6,
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _StageRings extends CustomPainter {
  const _StageRings();

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.43);
    final radius = size.shortestSide * 0.4;
    final line = Paint()
      ..style = PaintingStyle.stroke
      ..color = const Color(0x267DE2A7);
    canvas.drawCircle(center, radius, line);
    canvas.drawCircle(center, radius + 13, line);
  }

  @override
  bool shouldRepaint(_StageRings oldDelegate) => false;
}

class _AvatarModel extends StatefulWidget {
  const _AvatarModel({
    required this.character,
    required this.phase,
    required this.level,
    super.key,
  });

  final AvatarCharacter character;
  final AvatarPhase phase;
  final ValueListenable<double> level;

  @override
  State<_AvatarModel> createState() => _AvatarModelState();
}

class _AvatarModelState extends State<_AvatarModel>
    with WidgetsBindingObserver {
  final _model = Live2DViewController();
  bool _ready = false;
  bool _failed = false;
  int? _pose;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    widget.level.addListener(_updatePose);
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      await _model.whenAttached.timeout(const Duration(seconds: 6));
      if (!mounted) return;
      final loaded = await _model
          .loadModel(
            modelDir: widget.character.assetDirectory,
            modelFileName: widget.character.modelFile,
          )
          .timeout(const Duration(seconds: 25));
      if (!mounted) return;
      setState(() {
        _ready = loaded;
        _failed = !loaded;
      });
      _updatePose();
    } catch (_) {
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void didUpdateWidget(covariant _AvatarModel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.phase != widget.phase) _updatePose();
  }

  void _updatePose() {
    if (!_ready) return;
    final next = switch (widget.phase) {
      AvatarPhase.idle => 0,
      AvatarPhase.listening => 1,
      AvatarPhase.thinking => 2,
      AvatarPhase.speaking => 3 + (widget.level.value * 8).round(),
    };
    if (_pose == next) return;
    _pose = next;
    unawaited(_applyPose(next));
  }

  Future<void> _applyPose(int pose) async {
    try {
      await _model.setExpression(pose);
    } on Live2DException {
      if (mounted && _model.value.isLoaded) _pose = null;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!_ready) return;
    if (state == AppLifecycleState.hidden ||
        state == AppLifecycleState.paused) {
      unawaited(_setPaused(true));
    } else if (state == AppLifecycleState.resumed) {
      unawaited(_setPaused(false));
    }
  }

  Future<void> _setPaused(bool paused) async {
    try {
      await _model.setRenderingPaused(paused);
    } on Live2DException {
      // Android may detach the surface while the app goes to the background.
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    widget.level.removeListener(_updatePose);
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      ExcludeSemantics(
        child: Transform.scale(
          scale: widget.character.scale,
          alignment: Alignment(0, widget.character.alignmentY),
          child: Live2DView(controller: _model),
        ),
      ),
      if (!_ready)
        Center(
          child: _failed
              ? TextButton.icon(
                  onPressed: () {
                    setState(() => _failed = false);
                    unawaited(_load());
                  },
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('アバターを再読み込み'),
                )
              : const CircularProgressIndicator(color: _mint),
        ),
    ],
  );
}

class _Controls extends StatelessWidget {
  const _Controls({
    required this.avatar,
    required this.ready,
    required this.legacyRecording,
  });

  final AvatarConversation avatar;
  final bool ready;
  final bool legacyRecording;

  @override
  Widget build(BuildContext context) {
    final local = avatar.link == AvatarLink.local;
    final (title, hint, icon, label, action) = switch ((
      avatar.link,
      avatar.phase,
    )) {
      (AvatarLink.checking, _) => (
        '接続を確認中',
        'ローカルサーバーからの応答を待っています。',
        Icons.close_rounded,
        '接続確認をキャンセル',
        avatar.disconnectServer,
      ),
      (AvatarLink.calling, _) => (
        '通話を準備中',
        '音声接続を確立しています。',
        Icons.close_rounded,
        '通話をキャンセル',
        () => avatar.hangUp(),
      ),
      (AvatarLink.reconnecting, _) => (
        '音声を再接続中',
        '接続が戻ったら、途切れた内容をもう一度お話しください。',
        Icons.call_end_rounded,
        '再接続をキャンセル',
        () => avatar.hangUp(),
      ),
      (AvatarLink.connected, _) => (
        '通話を開始',
        'マイクのボタンを押して、日本語で話してください。',
        Icons.mic_none_rounded,
        '通話を開始',
        avatar.startCall,
      ),
      (AvatarLink.inCall, _) => (
        avatar.phase == AvatarPhase.speaking ? '話しています' : '聞いています',
        'マイクは通話中オンになります。',
        Icons.call_end_rounded,
        '通話を終了',
        () => avatar.hangUp(),
      ),
      (AvatarLink.local, AvatarPhase.listening) => (
        '録音中',
        'もう一度押すと録音を再生します。',
        Icons.play_arrow_rounded,
        '録音を再生',
        avatar.finishRecording,
      ),
      (AvatarLink.local, AvatarPhase.thinking) => (
        '再生を準備中',
        '音声を読み込んでいます。',
        Icons.close_rounded,
        'キャンセル',
        () => avatar.stopLocal(),
      ),
      (AvatarLink.local, AvatarPhase.speaking) => (
        '再生中',
        '音声に合わせて口が動きます。',
        Icons.stop_rounded,
        '再生を停止',
        () => avatar.stopLocal(),
      ),
      (AvatarLink.local, AvatarPhase.idle) => (
        '録音を試す',
        '録音した声をその場で再生します。',
        Icons.mic_none_rounded,
        '録音を開始',
        avatar.startRecording,
      ),
    };
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.3,
                          fontWeight: FontWeight.w800,
                          color: _ink,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      legacyRecording
                          ? 'Vox Local の録音を終了してください。'
                          : avatar.notice ?? hint,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.45,
                        color: avatar.notice == null
                            ? _muted
                            : const Color(0xFF8B392A),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              IconButton.filled(
                tooltip: label,
                onPressed: ready ? action : null,
                style: IconButton.styleFrom(
                  fixedSize: const Size.square(62),
                  backgroundColor:
                      local && avatar.phase == AvatarPhase.listening
                      ? _mint
                      : _ink,
                  foregroundColor:
                      local && avatar.phase == AvatarPhase.listening
                      ? _ink
                      : Colors.white,
                ),
                icon: Icon(icon, size: 27),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const Divider(height: 1, color: Color(0xFFD7DFD3)),
          SizedBox(
            height: 49,
            child: Row(
              children: [
                Expanded(
                  child: local
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                            ),
                            onPressed: ready && avatar.phase == AvatarPhase.idle
                                ? avatar.playSample
                                : null,
                            icon: const Icon(
                              Icons.volume_up_outlined,
                              size: 19,
                            ),
                            label: const Text('サンプル音声'),
                          ),
                        )
                      : avatar.cards.isEmpty
                      ? const Text(
                          'ローカルサーバー',
                          style: TextStyle(color: _muted, fontSize: 12),
                        )
                      : Align(
                          alignment: Alignment.centerLeft,
                          child: PopupMenuButton<String>(
                            tooltip: 'キャラクターカードを選択',
                            enabled:
                                ready && avatar.link == AvatarLink.connected,
                            initialValue: avatar.card,
                            onSelected: avatar.selectCard,
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'none',
                                child: Text('カードなし'),
                              ),
                              for (final card in avatar.cards)
                                PopupMenuItem(
                                  value: card.id,
                                  child: Text(card.name),
                                ),
                            ],
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 12,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: Text(
                                      avatar.cards
                                              .where(
                                                (item) =>
                                                    item.id == avatar.card,
                                              )
                                              .firstOrNull
                                              ?.name ??
                                          'カードなし',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: _ink,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down_rounded,
                                    color: _ink,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
                const Text(
                  '© Live2D Inc.',
                  style: TextStyle(color: _muted, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ServerDialog extends StatefulWidget {
  const _ServerDialog({
    required this.endpoint,
    required this.token,
    required this.onDisconnect,
  });

  final String endpoint;
  final String token;
  final VoidCallback? onDisconnect;

  @override
  State<_ServerDialog> createState() => _ServerDialogState();
}

class _ServerDialogState extends State<_ServerDialog> {
  late final _endpoint = TextEditingController(text: widget.endpoint);
  late final _token = TextEditingController(text: widget.token);
  late final _tokenFocus = FocusNode();
  String? _endpointError;
  String? _tokenError;
  bool _hideToken = true;

  void _submit() {
    final endpoint = AvatarConversation.parseEndpoint(_endpoint.text);
    final token = _token.text.trim();
    final validToken = RegExp(r'^[\x21-\x7E]+$').hasMatch(token);
    setState(() {
      _endpointError = endpoint == null ? 'サーバーの HTTP アドレスを入力してください。' : null;
      _tokenError = validToken ? null : 'アクセス用トークンを入力してください。';
    });
    if (endpoint == null || !validToken) return;
    Navigator.pop(context, (uri: endpoint, token: token));
  }

  @override
  void dispose() {
    _endpoint.dispose();
    _token.dispose();
    _tokenFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    scrollable: true,
    title: const Text('ローカルサーバーに接続'),
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text('同じネットワーク上の PC で「设置 → 局域网语音 API」を開き、表示された情報を入力してください。'),
        const SizedBox(height: 16),
        TextField(
          controller: _endpoint,
          autofocus: true,
          autocorrect: false,
          keyboardType: TextInputType.url,
          textInputAction: TextInputAction.next,
          onSubmitted: (_) => _tokenFocus.requestFocus(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'サーバーアドレス',
            hintText: 'http://192.168.1.20:4192',
            errorText: _endpointError,
          ),
        ),
        const SizedBox(height: 14),
        TextField(
          controller: _token,
          focusNode: _tokenFocus,
          obscureText: _hideToken,
          autocorrect: false,
          enableSuggestions: false,
          textInputAction: TextInputAction.go,
          onSubmitted: (_) => _submit(),
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: 'アクセス用トークン',
            errorText: _tokenError,
            suffixIcon: IconButton(
              tooltip: _hideToken ? 'トークンを表示' : 'トークンを隠す',
              onPressed: () => setState(() => _hideToken = !_hideToken),
              icon: Icon(
                _hideToken
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
              ),
            ),
          ),
        ),
      ],
    ),
    actions: [
      if (widget.onDisconnect case final onDisconnect?)
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            onDisconnect();
          },
          child: const Text('接続解除'),
        ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('キャンセル'),
      ),
      FilledButton(onPressed: _submit, child: const Text('接続を確認')),
    ],
  );
}
