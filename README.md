# Vox Local

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
flutter pub get
dart run tool/verify.dart   # コード再生成と差分チェック、format、analyze、test
```

iOS は WhisperKit（SwiftPM）に依存し、Android は CMake で whisper.cpp を取得するため、初回ビルドにはネットワーク接続が必要です。
