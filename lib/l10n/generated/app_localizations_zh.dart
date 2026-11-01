// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get listen => '聆听';

  @override
  String get analysis => '分析';

  @override
  String get settings => '设置';

  @override
  String get localSpeech => '本地语音';

  @override
  String get offlineModels => '离线模型';

  @override
  String get recognitionLanguage => '识别语言';

  @override
  String get autoDetect => '自动识别';

  @override
  String get conversationAnalysis => '对话分析';

  @override
  String get providerAndModel => '提供商与模型';

  @override
  String get notConfigured => '尚未配置';

  @override
  String get analysisTemplates => '分析模板';

  @override
  String get analysisInterval => '分析间隔';

  @override
  String get runtimeStatus => '运行状态';

  @override
  String get diagnostics => '诊断日志';

  @override
  String get diagnosticsSummary => '请求状态与重试记录，不含密钥和对话正文';

  @override
  String get privacyNotice => '语音在本地处理。只有开启在线分析，选定文字才会发送给提供商。API 密钥保存在系统安全存储中。';

  @override
  String get appLanguage => '界面语言';

  @override
  String get systemLanguage => '跟随系统';

  @override
  String get ready => '已就绪';

  @override
  String get notReady => '尚未就绪';

  @override
  String get turboDescription => '压缩版 · 多语言';

  @override
  String get smallDescription => '多语言 · 较低资源占用';

  @override
  String get modelActiveNotice => '录音期间保留当前模型。结束录音后可以切换或删除。';

  @override
  String get verifyingModel => '正在校验文件…';

  @override
  String get preparingModel => '正在从本机加载模型，首次加载可能较慢…';

  @override
  String get modelReady => '已就绪 · 可离线使用';

  @override
  String get modelInstalled => '已下载 · 等待准备';

  @override
  String get modelMissing => '尚未下载';

  @override
  String get inUse => '正在使用';

  @override
  String get prepareAndUse => '加载并使用';

  @override
  String get downloadAndPrepare => '下载并准备';

  @override
  String get deleteModel => '删除模型';

  @override
  String get modelAdvice =>
      '两个平台使用各自适配的模型文件。下载大小不代表运行内存；若设备持续发热或文字明显积压，请结束录音后尝试 Small。';

  @override
  String get cancel => '取消';

  @override
  String get delete => '删除';

  @override
  String get deleteModelBody => '删除后需要重新下载才能使用。对话记录会保留。';

  @override
  String get onlineAnalysis => '在线分析';

  @override
  String get configureProviderFirst => '先设置提供商、模型和密钥';

  @override
  String get analysisPrivacy => '开启后，这条记录已确认的文字会发送至所选提供商。暂停分析不影响本地转写。';

  @override
  String get retry => '重试';

  @override
  String get analysisResults => '分析结果';

  @override
  String get recentAnalysis => '显示这条记录最近 100 批分析；更早的结果仍保存在本地。';

  @override
  String get configureAnalysisProvider => '配置分析提供商';

  @override
  String get enableOnlineAnalysis => '开启在线分析';

  @override
  String get analyzeWhole => '整体重新分析';

  @override
  String get analyzeWholeHelp => '把完整转写一次性发送给模型，结果通常比分段分析更连贯。';

  @override
  String get wholeAnalysis => '整体分析';

  @override
  String get noMatch => '这段对话没有命中当前关注点。';

  @override
  String get viewOriginal => '查看原话';

  @override
  String get hideOriginal => '收起原话';

  @override
  String get provider => '提供商';

  @override
  String get compatibleProvider => '其他兼容接口';

  @override
  String get baseUrl => '接口基础地址';

  @override
  String get baseUrlHelp => '填写提供商的 HTTPS 地址；如需 /v1，请包含在地址中';

  @override
  String get apiKey => 'API 密钥';

  @override
  String get savedKeyHelp => '已保存密钥。留空可保留；不会在这里回显。';

  @override
  String get keyHelp => '仅保存到系统安全存储，不写入日志';

  @override
  String get showKey => '显示密钥';

  @override
  String get hideKey => '隐藏密钥';

  @override
  String get testConnection => '测试连接并获取模型';

  @override
  String get modelId => '模型 ID';

  @override
  String get modelIdHelp => '从列表选择，或填写提供商支持的模型 ID';

  @override
  String get chooseAvailableModel => '从可用模型中选择';

  @override
  String get saveConfiguration => '保存配置';

  @override
  String get configurationSaved => '配置已保存；分析请求将使用此模型';

  @override
  String get providerSaveHelp => '保存不要求联网。更换提供商不会自动转移旧任务；修复当前配置后，可在分析页手动重试。';

  @override
  String get savedTemplates => '预设与已保存模板';

  @override
  String get editTemplate => '编辑模板';

  @override
  String get customTemplate => '自定义模板';

  @override
  String get templateName => '模板名称';

  @override
  String get analysisRules => '分析规则';

  @override
  String get rulesHint => '例如：如果对话里提到预算，请整理金额、用途和需要确认的问题，并附原话依据。';

  @override
  String get listeningForRules => '正在聆听你的分析规则…';

  @override
  String get finishDictation => '结束并填入文字';

  @override
  String get dictateRules => '用语音输入规则';

  @override
  String get saveAndUse => '保存并使用';

  @override
  String get templateSaveHelp =>
      '规则只在保存后生效。更换规则后，当前记录会按新规则重新安排分析。语音草稿不会加入对话正文。';

  @override
  String get presetActions => '行动与待办';

  @override
  String get presetDecisions => '决策与分歧';

  @override
  String get presetRisks => '风险与疑问';

  @override
  String get presetActionsRules => '识别对话中明确提出的任务、负责人和时间；缺失信息列为待确认，不要编造。';

  @override
  String get presetDecisionsRules => '识别已经达成的决定、尚未解决的分歧和需要确认的问题。区分提议与最终决定。';

  @override
  String get presetRisksRules => '识别明确提及的风险、约束、依赖和未回答的问题，附原话依据。';

  @override
  String get openingMic => '正在开启麦克风';

  @override
  String get finalizingRecording => '正在处理最后一段';

  @override
  String get stopRecording => '结束录音';

  @override
  String get stopAndKeep => '结束并保留记录';

  @override
  String get preparingOfflineModel => '正在准备离线模型';

  @override
  String get chooseDownloadModel => '选择并下载离线模型';

  @override
  String get startNewRecording => '开始一段新记录';

  @override
  String get startRecording => '开始录音';

  @override
  String get transcript => '对话记录';

  @override
  String get recording => '正在录音';

  @override
  String get microphoneLevel => '麦克风音量';

  @override
  String get flowDescription => '录音转换为本地文字，可选择在线分析';

  @override
  String get recordAudio => '录音';

  @override
  String get localText => '本地文字';

  @override
  String get optionalAnalysis => '可选的在线分析';

  @override
  String get refreshLogs => '刷新日志';

  @override
  String get logPrivacy =>
      '仅记录运行状态、错误类别与重试次数。最多保留 300 条；此处显示最近 100 条，不包含密钥和对话正文。';

  @override
  String get noLogs => '还没有诊断记录。';

  @override
  String get analysisSucceeded => '分析完成';

  @override
  String get analysisFailed => '分析请求未完成';

  @override
  String get providerRequestFailed => '提供商请求未完成';

  @override
  String get modelPrepareFailedLog => '模型准备失败';

  @override
  String get speechStartFailedLog => '录音未能开始';

  @override
  String get speechInterruptedLog => '录音中断';

  @override
  String get runtimeLog => '运行状态记录';

  @override
  String get success => '成功';

  @override
  String get reopen => '重新打开';

  @override
  String get microphonePermission => '使用麦克风在设备本地将语音转换为文字。';

  @override
  String seconds(int count) {
    return '$count 秒';
  }

  @override
  String segmentCount(int count) {
    return '$count 个片段';
  }

  @override
  String downloadProgress(int percent) {
    return '正在下载 $percent%';
  }

  @override
  String analysisEvery(int seconds) {
    return '每 $seconds 秒检查新增文字';
  }

  @override
  String focusTemplate(String name) {
    return '关注：$name';
  }

  @override
  String waitingBatches(int count) {
    return '$count 批文字等待完成 · 你可以继续录音';
  }

  @override
  String openQuestions(String questions) {
    return '待确认：$questions';
  }

  @override
  String modelsFetched(int count) {
    return '连接成功，已获取 $count 个模型。';
  }

  @override
  String selectedTemplate(String name) {
    return '已选择：$name';
  }

  @override
  String editingTemplate(String name) {
    return '编辑：$name';
  }

  @override
  String retryAttempt(int count) {
    return '第 $count 次尝试';
  }

  @override
  String deleteModelTitle(String name) {
    return '删除 $name？';
  }

  @override
  String modelStatus(String name, String status) {
    return '$name · $status';
  }

  @override
  String message(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'operationFailed': '操作未完成，请检查状态后重试',
      'storageUnavailable': '本地数据暂时无法打开，请检查设备存储空间。',
      'engineUnavailable': '语音引擎暂不可用，请使用 iOS 或 Android 版本',
      'finishBeforeModelChange': '请先结束当前录音，再准备或切换模型',
      'finishRecordingFirst': '请先结束当前录音',
      'modelPrepareFailed': '模型准备失败，请检查网络与存储空间后重试',
      'modelDeleteFailed': '模型删除未完成，请检查设备存储后重试',
      'downloadModelFirst': '请先在设置中下载并准备离线模型',
      'speechStartFailed': '无法开始录音，请检查麦克风权限与模型状态',
      'speechInterrupted': '录音已中断，已完成的文字已保留',
      'audioInterrupted': '音频被系统中断，已完成的文字已保留，请结束后重新开始',
      'speechProcessingPaused': '语音处理已暂停，请检查设备空间或切换 Small 模型；已确认文字已保留',
      'transcriptSaveFailed': '文字保存失败，请检查设备剩余空间；原生记录将在下次启动时恢复',
      'speechStopFailed': '结束处理未完成，已确认文字已保留',
      'schedulingFailed': '分析调度暂不可用，转写仍会保留',
      'unsupportedInterval': '不支持的分析间隔',
      'unsupportedLocale': '不支持的界面语言',
      'unsupportedAnalysisLanguage': '不支持的分析输出语言',
      'configurationClearFailed': '配置未清除，请检查系统安全存储是否可用',
      'enterApiKey': '请输入此提供商的 API 密钥',
      'invalidTemplate': '请填写模板名称和分析规则，规则最多 4000 字',
      'invalidEndpoint': '接口地址必须是有效的 HTTPS 地址，不能包含密钥或查询参数',
      'enterModelId': '请选择或填写模型 ID',
      'budgetTooSmall': '模型输入或输出预算过小',
      'invalidRulesLength': '分析规则须为 1–4000 个字符',
      'rulesOverBudget': '分析规则超出当前输入预算',
      'segmentOverBudget': '单个转写片段超出输入预算',
      'transcriptOverBudget': '完整转写超出模型输入预算，无法一次性分析',
      'nothingToAnalyze': '这条记录还没有可分析的文字',
      'queueFull': '分析队列已满，原文已保留；请处理未完成任务后重试',
      'saveApiKey': '请在设置中保存 API 密钥',
      'analysisIncomplete': '分析暂未完成，请查看诊断记录',
      'invalidAnalysisResult': '模型返回的结果格式或原话引用无效，可手动重试',
      'responseTooLarge': '提供商返回内容过大',
      'analysisTimeout': '分析请求超时，稍后自动重试',
      'invalidCredentials': '密钥无效或无权使用此模型，请检查设置',
      'insufficientBalance': '提供商余额不足，请处理后重试',
      'rateLimited': '提供商限流，稍后自动重试',
      'providerUnavailable': '提供商暂时不可用，稍后自动重试',
      'invalidRequest': '接口地址、模型或请求参数不受支持，请检查设置',
      'analysisPaused': '分析已暂停',
      'invalidCertificate': '无法验证提供商的安全连接',
      'unparseableResponse': '提供商返回了无法解析的内容',
      'networkInterrupted': '网络连接中断，稍后自动重试',
      'responseContractMismatch': '提供商返回内容与接口契约不符',
      'emptyResponse': '提供商未返回有效的分析内容',
      'incompleteOutput': '模型输出未完整结束，请检查输出预算后重试',
      'noProviderModels': '提供商没有返回模型，可以手动填写模型 ID。',
      'fetchModelsFailed': '无法获取模型，可以检查设置或手动填写模型 ID。',
      'configurationSaveFailed': '配置未保存，请检查系统安全存储是否可用',
      'finishBeforeDictation': '请先结束对话录音，再使用语音编辑模板',
      'saveTemplateFailed': '模板保存失败，请重试',
      'analysisNeedsRetry': '部分分析需要重试，录音不受影响',
      'logsUnavailable': '日志暂时无法读取，录音和转写不受影响',
      'recordingOperationBusy': '正在处理记录，请稍候',
      'recordingNotFound': '这条记录已不存在，请返回记录列表',
      'invalidRecordingTitle': '请输入 1–80 个字符的记录名称',
      'recordingOpenFailed': '记录暂时无法打开，请重试',
      'recordingListFailed': '记录列表暂时无法读取，请下拉刷新或重试',
      'createNewRecordingFirst': '这条记录已结束，请新建录音',
      'chooseRecordingFirst': '请先打开或新建一条录音记录',
      'modelLoadFailed': '模型已下载，但加载失败。请重试加载或切换 Small；无需重复下载。',
      'other': '操作未完成，请检查状态后重试',
    });
    return '$_temp0';
  }

  @override
  String get deletingModel => '正在删除模型…';

  @override
  String get modelDeleteFailedLog => '模型删除失败';

  @override
  String diagnosticKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'network': '网络连接',
      'timeout': '超时',
      'rateLimited': '请求限流',
      'server': '提供商服务',
      'credentials': '密钥或权限',
      'balance': '提供商余额',
      'invalidRequest': '请求配置',
      'invalidResponse': '响应内容',
      'storage': '本地存储',
      'speech': '语音引擎',
      'cancelled': '已暂停',
      'storage_or_configuration': '存储或配置',
      'other': '运行状态',
    });
    return '$_temp0';
  }

  @override
  String get latestTranscript => '跳到最新文字';

  @override
  String get recordings => '记录';

  @override
  String get newRecording => '新录音';

  @override
  String get returnToRecording => '返回录音';

  @override
  String get analysisLanguage => '分析输出语言';

  @override
  String get clearProviderConfiguration => '清除配置';

  @override
  String get clearProviderTitle => '清除提供商配置？';

  @override
  String get clearProviderBody =>
      '将从系统安全存储中删除 API 密钥，并清空提供商与模型设置。已开启分析的记录会暂停，直到重新保存配置。';

  @override
  String get providerConfigurationCleared => '已清除提供商配置';

  @override
  String get noRecordings => '暂无录音记录';

  @override
  String get noMatchingRecordings => '没有匹配的记录';

  @override
  String get searchRecordings => '搜索标题或正文';

  @override
  String get clearSearch => '清空搜索';

  @override
  String get loadMoreRecordings => '加载更多记录';

  @override
  String get recordingActions => '记录操作';

  @override
  String get resumeRecording => '继续录音';

  @override
  String get finishRecordingBeforeResume => '请先结束当前录音再继续其他记录';

  @override
  String get renameRecording => '重命名';

  @override
  String get recordingName => '记录名称';

  @override
  String get saveRecordingName => '保存名称';

  @override
  String get copyTranscript => '复制全文';

  @override
  String get noTranscriptToCopy => '这条记录还没有已确认文字';

  @override
  String get transcriptCopied => '已复制全文';

  @override
  String get deleteRecording => '删除记录';

  @override
  String get deleteRecordingBody => '这会永久删除这条记录的文字、分析结果和恢复文件。下载的模型会保留。';

  @override
  String get finishRecordingBeforeDelete => '请先结束当前录音';

  @override
  String get recordingInterrupted => '已中断';

  @override
  String get recoveredRecordingNotice => '上次录音意外中断。已确认的文字已恢复，可以查看或新建录音。';

  @override
  String get noConfirmedTranscript => '这条记录没有已确认的文字';

  @override
  String get recordBeforeAnalysis => '开始录音后，可为这条记录开启在线分析';

  @override
  String get transcriptTab => '转写';

  @override
  String get localModelLoading => '加载本地模型';

  @override
  String get downloadModelToStart => '首次使用先下载离线模型，之后可重复使用';

  @override
  String recordingDateTitle(String date) {
    return '录音 $date';
  }

  @override
  String deleteRecordingTitle(String name) {
    return '删除“$name”？';
  }

  @override
  String savedRecordingDuration(String duration) {
    return '已保存 · $duration';
  }

  @override
  String pausedAnalysisBatches(int count) {
    return '$count 批分析已暂停';
  }

  @override
  String get recognitionPreview => '识别中 · 内容尚未确认';
}
