// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get listen => 'Listen';

  @override
  String get analysis => 'Analysis';

  @override
  String get settings => 'Settings';

  @override
  String get localSpeech => 'On-device speech';

  @override
  String get offlineModels => 'Offline models';

  @override
  String get recognitionLanguage => 'Speech language';

  @override
  String get autoDetect => 'Auto-detect';

  @override
  String get conversationAnalysis => 'Conversation analysis';

  @override
  String get providerAndModel => 'Provider & model';

  @override
  String get notConfigured => 'Not configured';

  @override
  String get analysisTemplates => 'Analysis templates';

  @override
  String get analysisInterval => 'Analysis interval';

  @override
  String get runtimeStatus => 'Runtime status';

  @override
  String get diagnostics => 'Diagnostics';

  @override
  String get diagnosticsSummary =>
      'Requests and retries, without keys or conversation text';

  @override
  String get privacyNotice =>
      'Speech is processed on your device. Selected text is sent to your provider only when online analysis is enabled. API keys are stored in system secure storage.';

  @override
  String get appLanguage => 'App language';

  @override
  String get systemLanguage => 'System default';

  @override
  String get ready => 'Ready';

  @override
  String get notReady => 'Not ready';

  @override
  String get turboDescription => 'Compressed · Multilingual';

  @override
  String get smallDescription => 'Multilingual · Lower resource use';

  @override
  String get modelActiveNotice =>
      'Finish recording before switching or deleting a model.';

  @override
  String get verifyingModel => 'Verifying files…';

  @override
  String get preparingModel =>
      'Loading the model from this device. The first load may take longer…';

  @override
  String get modelReady => 'Ready · Available offline';

  @override
  String get modelInstalled => 'Downloaded · Not loaded yet';

  @override
  String get modelMissing => 'Not downloaded';

  @override
  String get inUse => 'In use';

  @override
  String get prepareAndUse => 'Load & use';

  @override
  String get downloadAndPrepare => 'Download & prepare';

  @override
  String get deleteModel => 'Delete model';

  @override
  String get modelAdvice =>
      'Each platform uses its own model files. Download size is not runtime memory usage. If your device heats up or transcription falls behind, finish recording and try Small.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get deleteModelBody =>
      'You will need to download the model again to use it. Conversation records will be kept.';

  @override
  String get onlineAnalysis => 'Online analysis';

  @override
  String get configureProviderFirst =>
      'Set up a provider, model and API key first';

  @override
  String get analysisPrivacy =>
      'When enabled, confirmed text from this recording is sent to its selected provider. Pausing analysis does not affect local transcription.';

  @override
  String get retry => 'Retry';

  @override
  String get analysisResults => 'Analysis results';

  @override
  String get recentAnalysis =>
      'Showing the latest 100 analysis batches for this recording. Older results remain on this device.';

  @override
  String get configureAnalysisProvider => 'Set up analysis provider';

  @override
  String get enableOnlineAnalysis => 'Enable online analysis';

  @override
  String get analyzeWhole => 'Re-analyze whole transcript';

  @override
  String get analyzeWholeHelp =>
      'Sends the full transcript to the model in one request. Results are usually more coherent than batch analysis.';

  @override
  String get wholeAnalysis => 'Whole transcript';

  @override
  String get noMatch =>
      'No matches for the current analysis rules in this part of the conversation.';

  @override
  String get viewOriginal => 'View original text';

  @override
  String get hideOriginal => 'Hide original text';

  @override
  String get provider => 'Provider';

  @override
  String get compatibleProvider => 'Other compatible API';

  @override
  String get baseUrl => 'API base URL';

  @override
  String get baseUrlHelp =>
      'Enter the provider’s HTTPS URL, including /v1 if required';

  @override
  String get apiKey => 'API key';

  @override
  String get savedKeyHelp =>
      'A key is saved. Leave blank to keep it; it is never displayed here.';

  @override
  String get keyHelp => 'Saved only in system secure storage, never in logs';

  @override
  String get showKey => 'Show key';

  @override
  String get hideKey => 'Hide key';

  @override
  String get testConnection => 'Test connection & fetch models';

  @override
  String get modelId => 'Model ID';

  @override
  String get modelIdHelp =>
      'Choose from the list or enter a supported model ID';

  @override
  String get chooseAvailableModel => 'Choose an available model';

  @override
  String get saveConfiguration => 'Save configuration';

  @override
  String get configurationSaved =>
      'Configuration saved. Analysis will use this model.';

  @override
  String get providerSaveHelp =>
      'You can save offline. Changing providers does not move existing tasks. After fixing the current configuration, retry from Analysis.';

  @override
  String get savedTemplates => 'Presets & saved templates';

  @override
  String get editTemplate => 'Edit template';

  @override
  String get customTemplate => 'Custom template';

  @override
  String get templateName => 'Template name';

  @override
  String get analysisRules => 'Analysis rules';

  @override
  String get rulesHint =>
      'For example: If the conversation mentions a budget, list the amount, purpose and open questions, with supporting quotes.';

  @override
  String get listeningForRules => 'Listening for your analysis rules…';

  @override
  String get finishDictation => 'Finish & insert text';

  @override
  String get dictateRules => 'Dictate rules';

  @override
  String get saveAndUse => 'Save & use';

  @override
  String get templateSaveHelp =>
      'Rules take effect after saving. Changing rules schedules analysis of the current conversation with the new rules. Dictated drafts are not added to the conversation.';

  @override
  String get presetActions => 'Actions & tasks';

  @override
  String get presetDecisions => 'Decisions & disagreements';

  @override
  String get presetRisks => 'Risks & questions';

  @override
  String get presetActionsRules =>
      'Identify explicit tasks, owners and deadlines. Mark missing details as open questions; do not invent them.';

  @override
  String get presetDecisionsRules =>
      'Identify agreed decisions, unresolved disagreements and open questions. Distinguish proposals from final decisions.';

  @override
  String get presetRisksRules =>
      'Identify explicit risks, constraints, dependencies and unanswered questions, with supporting quotes.';

  @override
  String get openingMic => 'Opening microphone';

  @override
  String get finalizingRecording => 'Finishing the last segment';

  @override
  String get stopRecording => 'Stop recording';

  @override
  String get stopAndKeep => 'Stop & keep recording';

  @override
  String get preparingOfflineModel => 'Preparing offline model';

  @override
  String get chooseDownloadModel => 'Choose & download an offline model';

  @override
  String get startNewRecording => 'Start a new recording';

  @override
  String get startRecording => 'Start recording';

  @override
  String get transcript => 'Transcript';

  @override
  String get recording => 'Recording';

  @override
  String get microphoneLevel => 'Microphone level';

  @override
  String get flowDescription =>
      'Record audio, transcribe on device, optionally analyze online';

  @override
  String get recordAudio => 'Record audio';

  @override
  String get localText => 'On-device text';

  @override
  String get optionalAnalysis => 'Optional online analysis';

  @override
  String get refreshLogs => 'Refresh logs';

  @override
  String get logPrivacy =>
      'Only status, error categories and retry counts are logged. Up to 300 entries are kept; the latest 100 are shown. Keys and conversation text are excluded.';

  @override
  String get noLogs => 'No diagnostic entries yet.';

  @override
  String get analysisSucceeded => 'Analysis complete';

  @override
  String get analysisFailed => 'Analysis request failed';

  @override
  String get providerRequestFailed => 'Provider request failed';

  @override
  String get modelPrepareFailedLog => 'Model preparation failed';

  @override
  String get speechStartFailedLog => 'Recording could not start';

  @override
  String get speechInterruptedLog => 'Recording interrupted';

  @override
  String get runtimeLog => 'Runtime status';

  @override
  String get success => 'Success';

  @override
  String get reopen => 'Try again';

  @override
  String get microphonePermission =>
      'Use the microphone to transcribe speech on this device.';

  @override
  String seconds(int count) {
    return '$count s';
  }

  @override
  String segmentCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count segments',
      one: '1 segment',
    );
    return '$_temp0';
  }

  @override
  String downloadProgress(int percent) {
    return 'Downloading $percent%';
  }

  @override
  String analysisEvery(int seconds) {
    return 'Check for new text every $seconds seconds';
  }

  @override
  String focusTemplate(String name) {
    return 'Focus: $name';
  }

  @override
  String waitingBatches(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count batches pending · You can keep recording',
      one: '1 batch pending · You can keep recording',
    );
    return '$_temp0';
  }

  @override
  String openQuestions(String questions) {
    return 'Open questions: $questions';
  }

  @override
  String modelsFetched(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Connected. Fetched $count models.',
      one: 'Connected. Fetched 1 model.',
    );
    return '$_temp0';
  }

  @override
  String selectedTemplate(String name) {
    return 'Selected: $name';
  }

  @override
  String editingTemplate(String name) {
    return 'Edit: $name';
  }

  @override
  String retryAttempt(int count) {
    return 'Attempt $count';
  }

  @override
  String deleteModelTitle(String name) {
    return 'Delete $name?';
  }

  @override
  String modelStatus(String name, String status) {
    return '$name · $status';
  }

  @override
  String message(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'operationFailed': 'Operation failed. Check the status and try again.',
      'storageUnavailable':
          'Local data could not be opened. Check available device storage.',
      'engineUnavailable':
          'Speech engine unavailable. Use the iOS or Android app.',
      'finishBeforeModelChange':
          'Finish recording before loading or switching a model.',
      'finishRecordingFirst': 'Finish the current recording first.',
      'modelPrepareFailed': 'Model preparation failed. Check your connection and storage, then retry.',
      'modelDeleteFailed':
          'Model deletion failed. Check device storage and try again.',
      'downloadModelFirst':
          'Download and prepare an offline model in Settings first.',
      'speechStartFailed': 'Could not start recording. Check microphone permission and model status.',
      'speechInterrupted':
          'Recording interrupted. Confirmed text has been kept.',
      'audioInterrupted': 'Audio was interrupted by the system. Confirmed text was kept. Stop and start again.',
      'speechProcessingPaused': 'Speech processing paused. Check storage or switch to Small. Confirmed text has been kept.',
      'transcriptSaveFailed': 'Text could not be saved. Check storage. Native records will be recovered at the next launch.',
      'speechStopFailed':
          'Could not finish processing. Confirmed text has been kept.',
      'schedulingFailed':
          'Analysis scheduling is unavailable. Transcription is still kept.',
      'unsupportedInterval': 'Unsupported analysis interval.',
      'unsupportedLocale': 'Unsupported app language.',
      'unsupportedAnalysisLanguage': 'Unsupported analysis output language.',
      'configurationClearFailed': 'Configuration not cleared. Check system secure storage availability.',
      'enterApiKey': 'Enter this provider’s API key.',
      'invalidTemplate':
          'Enter a template name and rules of up to 4,000 characters.',
      'invalidEndpoint':
          'Use a valid HTTPS base URL without credentials or query parameters.',
      'enterModelId': 'Choose or enter a model ID.',
      'budgetTooSmall': 'The model input or output budget is too small.',
      'invalidRulesLength': 'Analysis rules must contain 1–4,000 characters.',
      'rulesOverBudget': 'Analysis rules exceed the input budget.',
      'segmentOverBudget': 'A transcript segment exceeds the input budget.',
      'transcriptOverBudget': 'The full transcript exceeds the model input budget and cannot be analyzed in one request.',
      'nothingToAnalyze': 'This recording has no text to analyze yet.',
      'queueFull': 'The analysis queue is full. Original text is kept. Resolve pending tasks and retry.',
      'saveApiKey': 'Save an API key in Settings.',
      'analysisIncomplete': 'Analysis is incomplete. Check Diagnostics.',
      'invalidAnalysisResult': 'The model returned an invalid format or quote reference. You can retry manually.',
      'responseTooLarge': 'The provider response is too large.',
      'analysisTimeout': 'Analysis timed out. It will retry automatically.',
      'invalidCredentials':
          'Invalid key or model access denied. Check Settings.',
      'insufficientBalance':
          'Provider balance is insufficient. Top up and retry.',
      'rateLimited':
          'Provider rate limit reached. It will retry automatically.',
      'providerUnavailable':
          'Provider temporarily unavailable. It will retry automatically.',
      'invalidRequest':
          'Unsupported endpoint, model or request parameters. Check Settings.',
      'analysisPaused': 'Analysis paused.',
      'invalidCertificate':
          'Could not verify the provider’s secure connection.',
      'unparseableResponse':
          'The provider returned content that could not be parsed.',
      'networkInterrupted':
          'Network connection interrupted. It will retry automatically.',
      'responseContractMismatch':
          'The provider response does not match the API format.',
      'emptyResponse': 'The provider returned no valid analysis.',
      'incompleteOutput':
          'Model output is incomplete. Check the output budget and retry.',
      'noProviderModels':
          'The provider returned no models. You can enter a model ID manually.',
      'fetchModelsFailed': 'Could not fetch models. Check Settings or enter a model ID manually.',
      'configurationSaveFailed':
          'Configuration not saved. Check system secure storage availability.',
      'finishBeforeDictation':
          'Finish the conversation recording before dictating a template.',
      'saveTemplateFailed': 'Could not save the template. Try again.',
      'analysisNeedsRetry':
          'Some analysis needs a retry. Recording is unaffected.',
      'logsUnavailable':
          'Logs are unavailable. Recording and transcription are unaffected.',
      'recordingOperationBusy':
          'A recording operation is in progress. Please wait.',
      'recordingNotFound':
          'This recording no longer exists. Return to Recordings.',
      'invalidRecordingTitle': 'Enter a recording name of 1–80 characters.',
      'recordingOpenFailed': 'Could not open the recording. Try again.',
      'recordingListFailed':
          'Could not load recordings. Pull to refresh or retry.',
      'createNewRecordingFirst':
          'This recording has ended. Start a new recording.',
      'chooseRecordingFirst': 'Open or create a recording first.',
      'modelLoadFailed': 'The model is downloaded but could not be loaded. Retry loading or switch to Small. No new download is required.',
      'other': 'Operation failed. Check the status and try again.',
    });
    return '$_temp0';
  }

  @override
  String get deletingModel => 'Deleting model…';

  @override
  String get modelDeleteFailedLog => 'Model deletion failed';

  @override
  String diagnosticKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'network': 'Network',
      'timeout': 'Timeout',
      'rateLimited': 'Rate limit',
      'server': 'Provider service',
      'credentials': 'Credentials',
      'balance': 'Provider balance',
      'invalidRequest': 'Request configuration',
      'invalidResponse': 'Response format',
      'storage': 'Local storage',
      'speech': 'Speech engine',
      'cancelled': 'Paused',
      'storage_or_configuration': 'Storage or configuration',
      'other': 'Runtime status',
    });
    return '$_temp0';
  }

  @override
  String get latestTranscript => 'Jump to latest text';

  @override
  String get recordings => 'Recordings';

  @override
  String get newRecording => 'New recording';

  @override
  String get returnToRecording => 'Return to recording';

  @override
  String get analysisLanguage => 'Analysis output language';

  @override
  String get clearProviderConfiguration => 'Clear configuration';

  @override
  String get clearProviderTitle => 'Clear provider configuration?';

  @override
  String get clearProviderBody =>
      'The API key is removed from system secure storage and the provider and model settings are reset. Recordings with analysis enabled pause until a configuration is saved again.';

  @override
  String get providerConfigurationCleared => 'Provider configuration cleared';

  @override
  String get noRecordings => 'No recordings yet';

  @override
  String get noMatchingRecordings => 'No matching recordings';

  @override
  String get searchRecordings => 'Search titles or text';

  @override
  String get clearSearch => 'Clear search';

  @override
  String get loadMoreRecordings => 'Load more recordings';

  @override
  String get recordingActions => 'Recording actions';

  @override
  String get resumeRecording => 'Resume recording';

  @override
  String get finishRecordingBeforeResume =>
      'Finish the current recording before resuming another';

  @override
  String get renameRecording => 'Rename';

  @override
  String get recordingName => 'Recording name';

  @override
  String get saveRecordingName => 'Save name';

  @override
  String get copyTranscript => 'Copy transcript';

  @override
  String get noTranscriptToCopy => 'This recording has no confirmed text yet.';

  @override
  String get transcriptCopied => 'Transcript copied';

  @override
  String get deleteRecording => 'Delete recording';

  @override
  String get deleteRecordingBody =>
      'This permanently deletes this recording’s text, analysis results and recovery files. Downloaded models are kept.';

  @override
  String get finishRecordingBeforeDelete =>
      'Finish the current recording first';

  @override
  String get recordingInterrupted => 'Interrupted';

  @override
  String get recoveredRecordingNotice =>
      'The last recording was interrupted. Confirmed text has been recovered. You can review it or start a new recording.';

  @override
  String get noConfirmedTranscript => 'No confirmed text in this recording';

  @override
  String get recordBeforeAnalysis =>
      'Start a recording to enable online analysis for it.';

  @override
  String get transcriptTab => 'Transcript';

  @override
  String get localModelLoading => 'Loading local model';

  @override
  String get downloadModelToStart =>
      'Download a model once, then reuse it offline.';

  @override
  String recordingDateTitle(String date) {
    return 'Recording $date';
  }

  @override
  String deleteRecordingTitle(String name) {
    return 'Delete “$name”?';
  }

  @override
  String savedRecordingDuration(String duration) {
    return 'Saved · $duration';
  }

  @override
  String pausedAnalysisBatches(int count) {
    return '$count analysis batches paused';
  }

  @override
  String get recognitionPreview => 'Recognizing · may change';
}
