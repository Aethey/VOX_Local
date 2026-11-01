# Vox Local

离线语音转写 App（Flutter，iOS / Android）。录音在设备上实时转成文字，不上传音频；转写结果可选配自己的大模型 API 做对话分析（待办、决策、风险等）。

## 功能

- 录音 → 本地实时转写，按时间线保存，支持中断后继续录制
- 记录库：搜索、重命名、复制、删除
- 可选的在线分析：自带/自定义分析模板，按设定间隔增量分析，结果附原文依据
- 界面语言：中文 / 日本語 / English

## 模型

**语音识别（本地运行，首次使用需下载）**

| 选项 | iOS（WhisperKit / Core ML） | Android（whisper.cpp v1.9.5 / GGML） |
| --- | --- | --- |
| Large V3 Turbo | `openai_whisper-large-v3-v20240930_626MB` | `ggml-large-v3-turbo-q5_0.bin` |
| Small | `openai_whisper-small` | `ggml-small-q5_1.bin` |

来源分别为 Hugging Face 的 `argmaxinc/whisperkit-coreml` 与 `ggerganov/whisper.cpp`。

**对话分析（可选，需自行配置）**

- DeepSeek
- 任意 OpenAI 兼容接口（`/chat/completions`），填写地址、API Key 和模型 ID

API Key 只存系统安全存储，不进日志。

## 开发

```sh
flutter pub get
dart run tool/verify.dart   # 重新生成代码并检查、format、analyze、test
```

iOS 依赖 WhisperKit（SwiftPM），Android 通过 CMake 拉取 whisper.cpp，首次构建需要联网。
