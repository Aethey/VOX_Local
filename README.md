# Vox Local

## Vox Live（Android 面談用デモ）

Android 版の起動画面で Live2D の百瀬ひよりが動きます。「アバター設定」から
わんころもちに切り替えられます。マイクを押して録音し、
もう一度押すと録音を再生します。「サンプル音声」から日本語の音声でも口の動きを
確認できます。ライブラリアイコンから従来の Vox Local に移動できます。

[わんころもちの公式ページ](https://www.live2d.com/learn/sample/wankoromochi/)から ZIP をダウンロードします。

```sh
python3 tool/prepare_avatar.py --wanko-archive /path/to/wanko_ja.zip
flutter pub get
flutter run
```

Android 版の対応 ABI は `arm64-v8a` と `x86_64` です。ビルドには
Android SDK の NDK `27.2.12479018`、CMake `3.22.1` と `patch` コマンドが必要です。
準備スクリプトは Live2D 公式サンプルを取得し、`live2d_flutter` 1.0.3 の
Android 用コピーを作成します。コピーには OpenGL シェーダーを含め、描画面の
初期化後にモデルを読み込む修正を適用します。

### Codex 音声のローカルサーバーに接続

1. PC と Android を同じネットワークに接続します。PC 版「Codex 语音」の
   「设置 → 局域网语音 API」でサーバーアドレスとアクセス用トークンを確認します。
2. App の「サーバーに接続」でアドレスとアクセストークンを入力し、「接続を確認」を
   押します。サービスを再起動した場合は、PC に表示される新しいトークンを入力します。
3. キャラクターカードは必要に応じて選択します。マイクのボタンを押すと通話が始まり、
   通話中はそのまま話せます。終了するには受話器のボタンを押します。

通話が途切れると「再接続中」と表示されます。短時間で復帰すれば元の通話が続きます。
復帰できなければ最大 2 回かけ直します。受話器ボタンで中止できます。
かけ直した後は、途切れた内容をもう一度話してください。

OpenAI API キーは PC 版の設定で指定します。
音声の送受信には同じ LAN 上で WebRTC の UDP 通信が必要です。

| リクエスト | 用途 |
| --- | --- |
| `GET /api/voice/settings` | 接続確認、キーの設定状況、キャラクターカードの取得 |
| `POST /api/voice/session` | UUID、ICE 収集済みの音声 SDP、言語 `auto`、カード ID を送信 |
| `GET /api/voice/session/{id}/events` | SSE で通話の開始と終了を受信 |
| `DELETE /api/voice/session/{id}` | 通話を終了 |

HTTP リクエストと SSE は Bearer トークンで認証します。音声は WebRTC で送受信し、
受信した音声のレベルで Live2D の口を動かします。

This content uses sample data owned and copyrighted by Live2D Inc. The sample data are utilized in accordance with terms and conditions set by Live2D Inc. This content itself is created at the author’s sole discretion.

[Live2D サンプルデータ利用条件](https://www.live2d.com/en/learn/sample/model-terms/) ·
[Live2D 無償提供マテリアル使用許諾契約書](https://www.live2d.com/eula/live2d-free-material-license-agreement_en.html)

## Vox Local（録音・文字起こし）

オフライン音声文字起こしアプリ（Flutter、iOS / Android）。録音を端末内でリアルタイムに文字起こしし、音声はアップロードしません。文字起こし結果は、任意で自分の LLM API を設定して会話分析（タスク・決定事項・リスクなど）に使えます。

## 機能

- 録音 → 端末内でリアルタイム文字起こし、タイムライン単位で保存、中断後の再開に対応
- 記録ライブラリ：検索・名前変更・コピー・削除
- 任意のオンライン分析：プリセット / カスタムの分析テンプレート、設定した間隔での差分分析、結果に原文の根拠を添付
- 表示言語：中文 / 日本語 / English

## モデル

**音声認識（端末内で実行、初回利用時にダウンロード）**

| 選択肢 | iOS（WhisperKit / Core ML） | Android（whisper.cpp v1.9.5 / GGML） |
| --- | --- | --- |
| Large V3 Turbo | `openai_whisper-large-v3-v20240930_626MB` | `ggml-large-v3-turbo-q5_0.bin` |
| Small | `openai_whisper-small` | `ggml-small-q5_1.bin` |

取得元はそれぞれ Hugging Face の `argmaxinc/whisperkit-coreml` と `ggerganov/whisper.cpp` です。

**会話分析（任意、要設定）**

- DeepSeek
- 任意の OpenAI 互換 API（`/chat/completions`）：エンドポイント、API キー、モデル ID を入力

API キーは OS のセキュアストレージにのみ保存し、ログには書き出しません。

## 開発

```sh
python3 tool/prepare_avatar.py --plugin-only
flutter pub get
dart run tool/verify.dart   # コード再生成と差分チェック、format、analyze、test
```

iOS は WhisperKit（SwiftPM）に依存し、Android は CMake で whisper.cpp を取得するため、初回ビルドにはネットワーク接続が必要です。
