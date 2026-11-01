import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
    Locale('zh'),
  ];

  /// No description provided for @listen.
  ///
  /// In en, this message translates to:
  /// **'Listen'**
  String get listen;

  /// No description provided for @analysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get analysis;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @localSpeech.
  ///
  /// In en, this message translates to:
  /// **'On-device speech'**
  String get localSpeech;

  /// No description provided for @offlineModels.
  ///
  /// In en, this message translates to:
  /// **'Offline models'**
  String get offlineModels;

  /// No description provided for @recognitionLanguage.
  ///
  /// In en, this message translates to:
  /// **'Speech language'**
  String get recognitionLanguage;

  /// No description provided for @autoDetect.
  ///
  /// In en, this message translates to:
  /// **'Auto-detect'**
  String get autoDetect;

  /// No description provided for @conversationAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Conversation analysis'**
  String get conversationAnalysis;

  /// No description provided for @providerAndModel.
  ///
  /// In en, this message translates to:
  /// **'Provider & model'**
  String get providerAndModel;

  /// No description provided for @notConfigured.
  ///
  /// In en, this message translates to:
  /// **'Not configured'**
  String get notConfigured;

  /// No description provided for @analysisTemplates.
  ///
  /// In en, this message translates to:
  /// **'Analysis templates'**
  String get analysisTemplates;

  /// No description provided for @analysisInterval.
  ///
  /// In en, this message translates to:
  /// **'Analysis interval'**
  String get analysisInterval;

  /// No description provided for @runtimeStatus.
  ///
  /// In en, this message translates to:
  /// **'Runtime status'**
  String get runtimeStatus;

  /// No description provided for @diagnostics.
  ///
  /// In en, this message translates to:
  /// **'Diagnostics'**
  String get diagnostics;

  /// No description provided for @diagnosticsSummary.
  ///
  /// In en, this message translates to:
  /// **'Requests and retries, without keys or conversation text'**
  String get diagnosticsSummary;

  /// No description provided for @privacyNotice.
  ///
  /// In en, this message translates to:
  /// **'Speech is processed on your device. Selected text is sent to your provider only when online analysis is enabled. API keys are stored in system secure storage.'**
  String get privacyNotice;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App language'**
  String get appLanguage;

  /// No description provided for @systemLanguage.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get systemLanguage;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @notReady.
  ///
  /// In en, this message translates to:
  /// **'Not ready'**
  String get notReady;

  /// No description provided for @turboDescription.
  ///
  /// In en, this message translates to:
  /// **'Compressed · Multilingual'**
  String get turboDescription;

  /// No description provided for @smallDescription.
  ///
  /// In en, this message translates to:
  /// **'Multilingual · Lower resource use'**
  String get smallDescription;

  /// No description provided for @modelActiveNotice.
  ///
  /// In en, this message translates to:
  /// **'Finish recording before switching or deleting a model.'**
  String get modelActiveNotice;

  /// No description provided for @verifyingModel.
  ///
  /// In en, this message translates to:
  /// **'Verifying files…'**
  String get verifyingModel;

  /// No description provided for @preparingModel.
  ///
  /// In en, this message translates to:
  /// **'Loading the model from this device. The first load may take longer…'**
  String get preparingModel;

  /// No description provided for @modelReady.
  ///
  /// In en, this message translates to:
  /// **'Ready · Available offline'**
  String get modelReady;

  /// No description provided for @modelInstalled.
  ///
  /// In en, this message translates to:
  /// **'Downloaded · Not loaded yet'**
  String get modelInstalled;

  /// No description provided for @modelMissing.
  ///
  /// In en, this message translates to:
  /// **'Not downloaded'**
  String get modelMissing;

  /// No description provided for @inUse.
  ///
  /// In en, this message translates to:
  /// **'In use'**
  String get inUse;

  /// No description provided for @prepareAndUse.
  ///
  /// In en, this message translates to:
  /// **'Load & use'**
  String get prepareAndUse;

  /// No description provided for @downloadAndPrepare.
  ///
  /// In en, this message translates to:
  /// **'Download & prepare'**
  String get downloadAndPrepare;

  /// No description provided for @deleteModel.
  ///
  /// In en, this message translates to:
  /// **'Delete model'**
  String get deleteModel;

  /// No description provided for @modelAdvice.
  ///
  /// In en, this message translates to:
  /// **'Each platform uses its own model files. Download size is not runtime memory usage. If your device heats up or transcription falls behind, finish recording and try Small.'**
  String get modelAdvice;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteModelBody.
  ///
  /// In en, this message translates to:
  /// **'You will need to download the model again to use it. Conversation records will be kept.'**
  String get deleteModelBody;

  /// No description provided for @onlineAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Online analysis'**
  String get onlineAnalysis;

  /// No description provided for @configureProviderFirst.
  ///
  /// In en, this message translates to:
  /// **'Set up a provider, model and API key first'**
  String get configureProviderFirst;

  /// No description provided for @analysisPrivacy.
  ///
  /// In en, this message translates to:
  /// **'When enabled, confirmed text from this recording is sent to its selected provider. Pausing analysis does not affect local transcription.'**
  String get analysisPrivacy;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @analysisResults.
  ///
  /// In en, this message translates to:
  /// **'Analysis results'**
  String get analysisResults;

  /// No description provided for @recentAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Showing the latest 100 analysis batches for this recording. Older results remain on this device.'**
  String get recentAnalysis;

  /// No description provided for @configureAnalysisProvider.
  ///
  /// In en, this message translates to:
  /// **'Set up analysis provider'**
  String get configureAnalysisProvider;

  /// No description provided for @enableOnlineAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Enable online analysis'**
  String get enableOnlineAnalysis;

  /// No description provided for @noMatch.
  ///
  /// In en, this message translates to:
  /// **'No matches for the current analysis rules in this part of the conversation.'**
  String get noMatch;

  /// No description provided for @viewOriginal.
  ///
  /// In en, this message translates to:
  /// **'View original text'**
  String get viewOriginal;

  /// No description provided for @hideOriginal.
  ///
  /// In en, this message translates to:
  /// **'Hide original text'**
  String get hideOriginal;

  /// No description provided for @provider.
  ///
  /// In en, this message translates to:
  /// **'Provider'**
  String get provider;

  /// No description provided for @compatibleProvider.
  ///
  /// In en, this message translates to:
  /// **'Other compatible API'**
  String get compatibleProvider;

  /// No description provided for @baseUrl.
  ///
  /// In en, this message translates to:
  /// **'API base URL'**
  String get baseUrl;

  /// No description provided for @baseUrlHelp.
  ///
  /// In en, this message translates to:
  /// **'Enter the provider’s HTTPS URL, including /v1 if required'**
  String get baseUrlHelp;

  /// No description provided for @apiKey.
  ///
  /// In en, this message translates to:
  /// **'API key'**
  String get apiKey;

  /// No description provided for @savedKeyHelp.
  ///
  /// In en, this message translates to:
  /// **'A key is saved. Leave blank to keep it; it is never displayed here.'**
  String get savedKeyHelp;

  /// No description provided for @keyHelp.
  ///
  /// In en, this message translates to:
  /// **'Saved only in system secure storage, never in logs'**
  String get keyHelp;

  /// No description provided for @showKey.
  ///
  /// In en, this message translates to:
  /// **'Show key'**
  String get showKey;

  /// No description provided for @hideKey.
  ///
  /// In en, this message translates to:
  /// **'Hide key'**
  String get hideKey;

  /// No description provided for @testConnection.
  ///
  /// In en, this message translates to:
  /// **'Test connection & fetch models'**
  String get testConnection;

  /// No description provided for @modelId.
  ///
  /// In en, this message translates to:
  /// **'Model ID'**
  String get modelId;

  /// No description provided for @modelIdHelp.
  ///
  /// In en, this message translates to:
  /// **'Choose from the list or enter a supported model ID'**
  String get modelIdHelp;

  /// No description provided for @chooseAvailableModel.
  ///
  /// In en, this message translates to:
  /// **'Choose an available model'**
  String get chooseAvailableModel;

  /// No description provided for @saveConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Save configuration'**
  String get saveConfiguration;

  /// No description provided for @configurationSaved.
  ///
  /// In en, this message translates to:
  /// **'Configuration saved. Analysis will use this model.'**
  String get configurationSaved;

  /// No description provided for @providerSaveHelp.
  ///
  /// In en, this message translates to:
  /// **'You can save offline. Changing providers does not move existing tasks. After fixing the current configuration, retry from Analysis.'**
  String get providerSaveHelp;

  /// No description provided for @savedTemplates.
  ///
  /// In en, this message translates to:
  /// **'Presets & saved templates'**
  String get savedTemplates;

  /// No description provided for @editTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit template'**
  String get editTemplate;

  /// No description provided for @customTemplate.
  ///
  /// In en, this message translates to:
  /// **'Custom template'**
  String get customTemplate;

  /// No description provided for @templateName.
  ///
  /// In en, this message translates to:
  /// **'Template name'**
  String get templateName;

  /// No description provided for @analysisRules.
  ///
  /// In en, this message translates to:
  /// **'Analysis rules'**
  String get analysisRules;

  /// No description provided for @rulesHint.
  ///
  /// In en, this message translates to:
  /// **'For example: If the conversation mentions a budget, list the amount, purpose and open questions, with supporting quotes.'**
  String get rulesHint;

  /// No description provided for @listeningForRules.
  ///
  /// In en, this message translates to:
  /// **'Listening for your analysis rules…'**
  String get listeningForRules;

  /// No description provided for @finishDictation.
  ///
  /// In en, this message translates to:
  /// **'Finish & insert text'**
  String get finishDictation;

  /// No description provided for @dictateRules.
  ///
  /// In en, this message translates to:
  /// **'Dictate rules'**
  String get dictateRules;

  /// No description provided for @saveAndUse.
  ///
  /// In en, this message translates to:
  /// **'Save & use'**
  String get saveAndUse;

  /// No description provided for @templateSaveHelp.
  ///
  /// In en, this message translates to:
  /// **'Rules take effect after saving. Changing rules schedules analysis of the current conversation with the new rules. Dictated drafts are not added to the conversation.'**
  String get templateSaveHelp;

  /// No description provided for @presetActions.
  ///
  /// In en, this message translates to:
  /// **'Actions & tasks'**
  String get presetActions;

  /// No description provided for @presetDecisions.
  ///
  /// In en, this message translates to:
  /// **'Decisions & disagreements'**
  String get presetDecisions;

  /// No description provided for @presetRisks.
  ///
  /// In en, this message translates to:
  /// **'Risks & questions'**
  String get presetRisks;

  /// No description provided for @presetActionsRules.
  ///
  /// In en, this message translates to:
  /// **'Identify explicit tasks, owners and deadlines. Mark missing details as open questions; do not invent them.'**
  String get presetActionsRules;

  /// No description provided for @presetDecisionsRules.
  ///
  /// In en, this message translates to:
  /// **'Identify agreed decisions, unresolved disagreements and open questions. Distinguish proposals from final decisions.'**
  String get presetDecisionsRules;

  /// No description provided for @presetRisksRules.
  ///
  /// In en, this message translates to:
  /// **'Identify explicit risks, constraints, dependencies and unanswered questions, with supporting quotes.'**
  String get presetRisksRules;

  /// No description provided for @openingMic.
  ///
  /// In en, this message translates to:
  /// **'Opening microphone'**
  String get openingMic;

  /// No description provided for @finalizingRecording.
  ///
  /// In en, this message translates to:
  /// **'Finishing the last segment'**
  String get finalizingRecording;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get stopRecording;

  /// No description provided for @stopAndKeep.
  ///
  /// In en, this message translates to:
  /// **'Stop & keep recording'**
  String get stopAndKeep;

  /// No description provided for @preparingOfflineModel.
  ///
  /// In en, this message translates to:
  /// **'Preparing offline model'**
  String get preparingOfflineModel;

  /// No description provided for @chooseDownloadModel.
  ///
  /// In en, this message translates to:
  /// **'Choose & download an offline model'**
  String get chooseDownloadModel;

  /// No description provided for @startNewRecording.
  ///
  /// In en, this message translates to:
  /// **'Start a new recording'**
  String get startNewRecording;

  /// No description provided for @startRecording.
  ///
  /// In en, this message translates to:
  /// **'Start recording'**
  String get startRecording;

  /// No description provided for @transcript.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get transcript;

  /// No description provided for @recording.
  ///
  /// In en, this message translates to:
  /// **'Recording'**
  String get recording;

  /// No description provided for @microphoneLevel.
  ///
  /// In en, this message translates to:
  /// **'Microphone level'**
  String get microphoneLevel;

  /// No description provided for @flowDescription.
  ///
  /// In en, this message translates to:
  /// **'Record audio, transcribe on device, optionally analyze online'**
  String get flowDescription;

  /// No description provided for @recordAudio.
  ///
  /// In en, this message translates to:
  /// **'Record audio'**
  String get recordAudio;

  /// No description provided for @localText.
  ///
  /// In en, this message translates to:
  /// **'On-device text'**
  String get localText;

  /// No description provided for @optionalAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Optional online analysis'**
  String get optionalAnalysis;

  /// No description provided for @refreshLogs.
  ///
  /// In en, this message translates to:
  /// **'Refresh logs'**
  String get refreshLogs;

  /// No description provided for @logPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Only status, error categories and retry counts are logged. Up to 300 entries are kept; the latest 100 are shown. Keys and conversation text are excluded.'**
  String get logPrivacy;

  /// No description provided for @noLogs.
  ///
  /// In en, this message translates to:
  /// **'No diagnostic entries yet.'**
  String get noLogs;

  /// No description provided for @analysisSucceeded.
  ///
  /// In en, this message translates to:
  /// **'Analysis complete'**
  String get analysisSucceeded;

  /// No description provided for @analysisFailed.
  ///
  /// In en, this message translates to:
  /// **'Analysis request failed'**
  String get analysisFailed;

  /// No description provided for @providerRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Provider request failed'**
  String get providerRequestFailed;

  /// No description provided for @modelPrepareFailedLog.
  ///
  /// In en, this message translates to:
  /// **'Model preparation failed'**
  String get modelPrepareFailedLog;

  /// No description provided for @speechStartFailedLog.
  ///
  /// In en, this message translates to:
  /// **'Recording could not start'**
  String get speechStartFailedLog;

  /// No description provided for @speechInterruptedLog.
  ///
  /// In en, this message translates to:
  /// **'Recording interrupted'**
  String get speechInterruptedLog;

  /// No description provided for @runtimeLog.
  ///
  /// In en, this message translates to:
  /// **'Runtime status'**
  String get runtimeLog;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @reopen.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get reopen;

  /// No description provided for @microphonePermission.
  ///
  /// In en, this message translates to:
  /// **'Use the microphone to transcribe speech on this device.'**
  String get microphonePermission;

  /// No description provided for @seconds.
  ///
  /// In en, this message translates to:
  /// **'{count} s'**
  String seconds(int count);

  /// No description provided for @segmentCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 segment} other{{count} segments}}'**
  String segmentCount(int count);

  /// No description provided for @downloadProgress.
  ///
  /// In en, this message translates to:
  /// **'Downloading {percent}%'**
  String downloadProgress(int percent);

  /// No description provided for @analysisEvery.
  ///
  /// In en, this message translates to:
  /// **'Check for new text every {seconds} seconds'**
  String analysisEvery(int seconds);

  /// No description provided for @focusTemplate.
  ///
  /// In en, this message translates to:
  /// **'Focus: {name}'**
  String focusTemplate(String name);

  /// No description provided for @waitingBatches.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 batch pending · You can keep recording} other{{count} batches pending · You can keep recording}}'**
  String waitingBatches(int count);

  /// No description provided for @openQuestions.
  ///
  /// In en, this message translates to:
  /// **'Open questions: {questions}'**
  String openQuestions(String questions);

  /// No description provided for @modelsFetched.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Connected. Fetched 1 model.} other{Connected. Fetched {count} models.}}'**
  String modelsFetched(int count);

  /// No description provided for @selectedTemplate.
  ///
  /// In en, this message translates to:
  /// **'Selected: {name}'**
  String selectedTemplate(String name);

  /// No description provided for @editingTemplate.
  ///
  /// In en, this message translates to:
  /// **'Edit: {name}'**
  String editingTemplate(String name);

  /// No description provided for @retryAttempt.
  ///
  /// In en, this message translates to:
  /// **'Attempt {count}'**
  String retryAttempt(int count);

  /// No description provided for @deleteModelTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete {name}?'**
  String deleteModelTitle(String name);

  /// No description provided for @modelStatus.
  ///
  /// In en, this message translates to:
  /// **'{name} · {status}'**
  String modelStatus(String name, String status);

  /// Stable application and native error codes; unknown or legacy messages use a safe localized fallback.
  ///
  /// In en, this message translates to:
  /// **'{code, select, operationFailed {Operation failed. Check the status and try again.} storageUnavailable {Local data could not be opened. Check available device storage.} engineUnavailable {Speech engine unavailable. Use the iOS or Android app.} finishBeforeModelChange {Finish recording before loading or switching a model.} finishRecordingFirst {Finish the current recording first.} modelPrepareFailed {Model preparation failed. Check your connection and storage, then retry.} modelDeleteFailed {Model deletion failed. Check device storage and try again.} downloadModelFirst {Download and prepare an offline model in Settings first.} speechStartFailed {Could not start recording. Check microphone permission and model status.} speechInterrupted {Recording interrupted. Confirmed text has been kept.} audioInterrupted {Audio was interrupted by the system. Confirmed text was kept. Stop and start again.} speechProcessingPaused {Speech processing paused. Check storage or switch to Small. Confirmed text has been kept.} transcriptSaveFailed {Text could not be saved. Check storage. Native records will be recovered at the next launch.} speechStopFailed {Could not finish processing. Confirmed text has been kept.} schedulingFailed {Analysis scheduling is unavailable. Transcription is still kept.} unsupportedInterval {Unsupported analysis interval.} unsupportedLocale {Unsupported app language.} unsupportedAnalysisLanguage {Unsupported analysis output language.} configurationClearFailed {Configuration not cleared. Check system secure storage availability.} enterApiKey {Enter this provider’s API key.} invalidTemplate {Enter a template name and rules of up to 4,000 characters.} invalidEndpoint {Use a valid HTTPS base URL without credentials or query parameters.} enterModelId {Choose or enter a model ID.} budgetTooSmall {The model input or output budget is too small.} invalidRulesLength {Analysis rules must contain 1–4,000 characters.} rulesOverBudget {Analysis rules exceed the input budget.} segmentOverBudget {A transcript segment exceeds the input budget.} queueFull {The analysis queue is full. Original text is kept. Resolve pending tasks and retry.} saveApiKey {Save an API key in Settings.} analysisIncomplete {Analysis is incomplete. Check Diagnostics.} invalidAnalysisResult {The model returned an invalid format or quote reference. You can retry manually.} responseTooLarge {The provider response is too large.} analysisTimeout {Analysis timed out. It will retry automatically.} invalidCredentials {Invalid key or model access denied. Check Settings.} insufficientBalance {Provider balance is insufficient. Top up and retry.} rateLimited {Provider rate limit reached. It will retry automatically.} providerUnavailable {Provider temporarily unavailable. It will retry automatically.} invalidRequest {Unsupported endpoint, model or request parameters. Check Settings.} analysisPaused {Analysis paused.} invalidCertificate {Could not verify the provider’s secure connection.} unparseableResponse {The provider returned content that could not be parsed.} networkInterrupted {Network connection interrupted. It will retry automatically.} responseContractMismatch {The provider response does not match the API format.} emptyResponse {The provider returned no valid analysis.} incompleteOutput {Model output is incomplete. Check the output budget and retry.} noProviderModels {The provider returned no models. You can enter a model ID manually.} fetchModelsFailed {Could not fetch models. Check Settings or enter a model ID manually.} configurationSaveFailed {Configuration not saved. Check system secure storage availability.} finishBeforeDictation {Finish the conversation recording before dictating a template.} saveTemplateFailed {Could not save the template. Try again.} analysisNeedsRetry {Some analysis needs a retry. Recording is unaffected.} logsUnavailable {Logs are unavailable. Recording and transcription are unaffected.} recordingOperationBusy {A recording operation is in progress. Please wait.} recordingNotFound {This recording no longer exists. Return to Recordings.} invalidRecordingTitle {Enter a recording name of 1–80 characters.} recordingOpenFailed {Could not open the recording. Try again.} recordingListFailed {Could not load recordings. Pull to refresh or retry.} createNewRecordingFirst {This recording has ended. Start a new recording.} chooseRecordingFirst {Open or create a recording first.} modelLoadFailed {The model is downloaded but could not be loaded. Retry loading or switch to Small. No new download is required.} other {Operation failed. Check the status and try again.}}'**
  String message(String code);

  /// No description provided for @deletingModel.
  ///
  /// In en, this message translates to:
  /// **'Deleting model…'**
  String get deletingModel;

  /// No description provided for @modelDeleteFailedLog.
  ///
  /// In en, this message translates to:
  /// **'Model deletion failed'**
  String get modelDeleteFailedLog;

  /// No description provided for @diagnosticKind.
  ///
  /// In en, this message translates to:
  /// **'{kind, select, network {Network} timeout {Timeout} rateLimited {Rate limit} server {Provider service} credentials {Credentials} balance {Provider balance} invalidRequest {Request configuration} invalidResponse {Response format} storage {Local storage} speech {Speech engine} cancelled {Paused} storage_or_configuration {Storage or configuration} other {Runtime status}}'**
  String diagnosticKind(String kind);

  /// No description provided for @latestTranscript.
  ///
  /// In en, this message translates to:
  /// **'Jump to latest text'**
  String get latestTranscript;

  /// No description provided for @recordings.
  ///
  /// In en, this message translates to:
  /// **'Recordings'**
  String get recordings;

  /// No description provided for @newRecording.
  ///
  /// In en, this message translates to:
  /// **'New recording'**
  String get newRecording;

  /// No description provided for @returnToRecording.
  ///
  /// In en, this message translates to:
  /// **'Return to recording'**
  String get returnToRecording;

  /// No description provided for @analysisLanguage.
  ///
  /// In en, this message translates to:
  /// **'Analysis output language'**
  String get analysisLanguage;

  /// No description provided for @clearProviderConfiguration.
  ///
  /// In en, this message translates to:
  /// **'Clear configuration'**
  String get clearProviderConfiguration;

  /// No description provided for @clearProviderTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear provider configuration?'**
  String get clearProviderTitle;

  /// No description provided for @clearProviderBody.
  ///
  /// In en, this message translates to:
  /// **'The API key is removed from system secure storage and the provider and model settings are reset. Recordings with analysis enabled pause until a configuration is saved again.'**
  String get clearProviderBody;

  /// No description provided for @providerConfigurationCleared.
  ///
  /// In en, this message translates to:
  /// **'Provider configuration cleared'**
  String get providerConfigurationCleared;

  /// No description provided for @noRecordings.
  ///
  /// In en, this message translates to:
  /// **'No recordings yet'**
  String get noRecordings;

  /// No description provided for @noMatchingRecordings.
  ///
  /// In en, this message translates to:
  /// **'No matching recordings'**
  String get noMatchingRecordings;

  /// No description provided for @searchRecordings.
  ///
  /// In en, this message translates to:
  /// **'Search titles or text'**
  String get searchRecordings;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clearSearch;

  /// No description provided for @loadMoreRecordings.
  ///
  /// In en, this message translates to:
  /// **'Load more recordings'**
  String get loadMoreRecordings;

  /// No description provided for @recordingActions.
  ///
  /// In en, this message translates to:
  /// **'Recording actions'**
  String get recordingActions;

  /// No description provided for @resumeRecording.
  ///
  /// In en, this message translates to:
  /// **'Resume recording'**
  String get resumeRecording;

  /// No description provided for @finishRecordingBeforeResume.
  ///
  /// In en, this message translates to:
  /// **'Finish the current recording before resuming another'**
  String get finishRecordingBeforeResume;

  /// No description provided for @renameRecording.
  ///
  /// In en, this message translates to:
  /// **'Rename'**
  String get renameRecording;

  /// No description provided for @recordingName.
  ///
  /// In en, this message translates to:
  /// **'Recording name'**
  String get recordingName;

  /// No description provided for @saveRecordingName.
  ///
  /// In en, this message translates to:
  /// **'Save name'**
  String get saveRecordingName;

  /// No description provided for @copyTranscript.
  ///
  /// In en, this message translates to:
  /// **'Copy transcript'**
  String get copyTranscript;

  /// No description provided for @noTranscriptToCopy.
  ///
  /// In en, this message translates to:
  /// **'This recording has no confirmed text yet.'**
  String get noTranscriptToCopy;

  /// No description provided for @transcriptCopied.
  ///
  /// In en, this message translates to:
  /// **'Transcript copied'**
  String get transcriptCopied;

  /// No description provided for @deleteRecording.
  ///
  /// In en, this message translates to:
  /// **'Delete recording'**
  String get deleteRecording;

  /// No description provided for @deleteRecordingBody.
  ///
  /// In en, this message translates to:
  /// **'This permanently deletes this recording’s text, analysis results and recovery files. Downloaded models are kept.'**
  String get deleteRecordingBody;

  /// No description provided for @finishRecordingBeforeDelete.
  ///
  /// In en, this message translates to:
  /// **'Finish the current recording first'**
  String get finishRecordingBeforeDelete;

  /// No description provided for @recordingInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Interrupted'**
  String get recordingInterrupted;

  /// No description provided for @recoveredRecordingNotice.
  ///
  /// In en, this message translates to:
  /// **'The last recording was interrupted. Confirmed text has been recovered. You can review it or start a new recording.'**
  String get recoveredRecordingNotice;

  /// No description provided for @noConfirmedTranscript.
  ///
  /// In en, this message translates to:
  /// **'No confirmed text in this recording'**
  String get noConfirmedTranscript;

  /// No description provided for @recordBeforeAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Start a recording to enable online analysis for it.'**
  String get recordBeforeAnalysis;

  /// No description provided for @transcriptTab.
  ///
  /// In en, this message translates to:
  /// **'Transcript'**
  String get transcriptTab;

  /// No description provided for @localModelLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading local model'**
  String get localModelLoading;

  /// No description provided for @downloadModelToStart.
  ///
  /// In en, this message translates to:
  /// **'Download a model once, then reuse it offline.'**
  String get downloadModelToStart;

  /// No description provided for @recordingDateTitle.
  ///
  /// In en, this message translates to:
  /// **'Recording {date}'**
  String recordingDateTitle(String date);

  /// No description provided for @deleteRecordingTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete “{name}”?'**
  String deleteRecordingTitle(String name);

  /// No description provided for @savedRecordingDuration.
  ///
  /// In en, this message translates to:
  /// **'Saved · {duration}'**
  String savedRecordingDuration(String duration);

  /// No description provided for @pausedAnalysisBatches.
  ///
  /// In en, this message translates to:
  /// **'{count} analysis batches paused'**
  String pausedAnalysisBatches(int count);

  /// No description provided for @recognitionPreview.
  ///
  /// In en, this message translates to:
  /// **'Recognizing · may change'**
  String get recognitionPreview;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ja':
      return AppLocalizationsJa();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
