// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get listen => '録音';

  @override
  String get analysis => '分析';

  @override
  String get settings => '設定';

  @override
  String get localSpeech => '端末内の音声認識';

  @override
  String get offlineModels => 'オフラインモデル';

  @override
  String get recognitionLanguage => '認識言語';

  @override
  String get autoDetect => '自動検出';

  @override
  String get conversationAnalysis => '会話の分析';

  @override
  String get providerAndModel => 'プロバイダーとモデル';

  @override
  String get notConfigured => '未設定';

  @override
  String get analysisTemplates => '分析テンプレート';

  @override
  String get analysisInterval => '分析間隔';

  @override
  String get runtimeStatus => '動作状況';

  @override
  String get diagnostics => '診断ログ';

  @override
  String get diagnosticsSummary => 'リクエストと再試行の記録。キーや会話本文は含みません';

  @override
  String get privacyNotice =>
      '音声は端末内で処理されます。オンライン分析を有効にした場合のみ、対象のテキストがプロバイダーに送信されます。API キーはシステムの安全なストレージに保存されます。';

  @override
  String get appLanguage => '表示言語';

  @override
  String get systemLanguage => 'システムに合わせる';

  @override
  String get ready => '準備完了';

  @override
  String get notReady => '未準備';

  @override
  String get turboDescription => '圧縮版・多言語';

  @override
  String get smallDescription => '多言語・省リソース';

  @override
  String get modelActiveNotice => 'モデルの切り替えや削除は録音終了後に行えます。';

  @override
  String get verifyingModel => 'ファイルを検証中…';

  @override
  String get preparingModel => '端末内のモデルを読み込み中。初回は時間がかかる場合があります…';

  @override
  String get modelReady => '準備完了・オフラインで利用可能';

  @override
  String get modelInstalled => 'ダウンロード済み・読み込み前';

  @override
  String get modelMissing => '未ダウンロード';

  @override
  String get inUse => '使用中';

  @override
  String get prepareAndUse => '読み込んで使用';

  @override
  String get downloadAndPrepare => 'ダウンロードして準備';

  @override
  String get deleteModel => 'モデルを削除';

  @override
  String get modelAdvice =>
      '各プラットフォームに対応したモデルを使用します。ダウンロードサイズと実行時のメモリ使用量は異なります。発熱や文字起こしの遅延が続く場合は、録音終了後に Small をお試しください。';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get deleteModelBody => '再び使用するにはダウンロードが必要です。会話の記録は保持されます。';

  @override
  String get onlineAnalysis => 'オンライン分析';

  @override
  String get configureProviderFirst => '先にプロバイダー、モデル、API キーを設定してください';

  @override
  String get analysisPrivacy =>
      '有効にすると、この記録の確定したテキストが選択したプロバイダーに送信されます。分析を一時停止しても端末内の文字起こしには影響しません。';

  @override
  String get retry => '再試行';

  @override
  String get analysisResults => '分析結果';

  @override
  String get recentAnalysis => 'この記録の最新 100 件の分析を表示しています。過去の結果も端末内に保存されています。';

  @override
  String get configureAnalysisProvider => '分析プロバイダーを設定';

  @override
  String get enableOnlineAnalysis => 'オンライン分析を有効にする';

  @override
  String get analyzeWhole => '全体を再分析';

  @override
  String get analyzeWholeHelp => '文字起こし全体を一度にモデルへ送ります。分割分析より一貫した結果になりやすくなります。';

  @override
  String get wholeAnalysis => '全体分析';

  @override
  String get noMatch => 'この会話には現在の分析ルールに該当する内容がありません。';

  @override
  String get viewOriginal => '原文を表示';

  @override
  String get hideOriginal => '原文を閉じる';

  @override
  String get provider => 'プロバイダー';

  @override
  String get compatibleProvider => 'その他の互換 API';

  @override
  String get baseUrl => 'API ベース URL';

  @override
  String get baseUrlHelp => 'プロバイダーの HTTPS URL を入力してください。必要に応じて /v1 を含めてください';

  @override
  String get apiKey => 'API キー';

  @override
  String get savedKeyHelp => 'キーは保存済みです。空欄のままで保持できます。ここには表示されません。';

  @override
  String get keyHelp => 'システムの安全なストレージにのみ保存され、ログには記録されません';

  @override
  String get showKey => 'キーを表示';

  @override
  String get hideKey => 'キーを隠す';

  @override
  String get testConnection => '接続テストとモデル取得';

  @override
  String get modelId => 'モデル ID';

  @override
  String get modelIdHelp => '一覧から選択するか、対応するモデル ID を入力してください';

  @override
  String get chooseAvailableModel => '利用可能なモデルから選択';

  @override
  String get saveConfiguration => '設定を保存';

  @override
  String get configurationSaved => '設定を保存しました。このモデルで分析します。';

  @override
  String get providerSaveHelp =>
      'オフラインでも保存できます。プロバイダーを変更しても既存のタスクは移行されません。現在の設定を修正した後、分析画面で再試行できます。';

  @override
  String get savedTemplates => 'プリセットと保存済みテンプレート';

  @override
  String get editTemplate => 'テンプレートを編集';

  @override
  String get customTemplate => 'カスタムテンプレート';

  @override
  String get templateName => 'テンプレート名';

  @override
  String get analysisRules => '分析ルール';

  @override
  String get rulesHint => '例：会話で予算に触れたら、金額、用途、確認事項を整理し、根拠となる原文を添えてください。';

  @override
  String get listeningForRules => '分析ルールを聞き取り中…';

  @override
  String get finishDictation => '終了してテキストを挿入';

  @override
  String get dictateRules => '音声でルールを入力';

  @override
  String get saveAndUse => '保存して使用';

  @override
  String get templateSaveHelp =>
      'ルールは保存後に適用されます。変更すると、現在の会話が新しいルールで分析されます。音声入力の下書きは会話本文には追加されません。';

  @override
  String get presetActions => 'アクションとタスク';

  @override
  String get presetDecisions => '決定と意見の相違';

  @override
  String get presetRisks => 'リスクと疑問';

  @override
  String get presetActionsRules =>
      '会話で明示されたタスク、担当者、期限を特定してください。不足する情報は確認事項とし、推測で補わないでください。';

  @override
  String get presetDecisionsRules =>
      '合意された決定、未解決の意見の相違、確認事項を特定してください。提案と最終決定を区別してください。';

  @override
  String get presetRisksRules =>
      '明示されたリスク、制約、依存関係、未回答の疑問を、根拠となる原文とともに特定してください。';

  @override
  String get openingMic => 'マイクを起動中';

  @override
  String get finalizingRecording => '最後の区間を処理中';

  @override
  String get stopRecording => '録音を終了';

  @override
  String get stopAndKeep => '終了して記録を保持';

  @override
  String get preparingOfflineModel => 'オフラインモデルを準備中';

  @override
  String get chooseDownloadModel => 'オフラインモデルを選んでダウンロード';

  @override
  String get startNewRecording => '新しく録音を開始';

  @override
  String get startRecording => '録音を開始';

  @override
  String get transcript => '会話の記録';

  @override
  String get recording => '録音中';

  @override
  String get microphoneLevel => 'マイク音量';

  @override
  String get flowDescription => '録音を端末内で文字起こしし、必要に応じてオンラインで分析します';

  @override
  String get recordAudio => '録音';

  @override
  String get localText => '端末内のテキスト';

  @override
  String get optionalAnalysis => '任意のオンライン分析';

  @override
  String get refreshLogs => 'ログを更新';

  @override
  String get logPrivacy =>
      '動作状況、エラー種別、再試行回数のみを記録します。最大 300 件を保存し、最新 100 件を表示します。キーや会話本文は含まれません。';

  @override
  String get noLogs => '診断ログはまだありません。';

  @override
  String get analysisSucceeded => '分析完了';

  @override
  String get analysisFailed => '分析リクエスト失敗';

  @override
  String get providerRequestFailed => 'プロバイダーへのリクエスト失敗';

  @override
  String get modelPrepareFailedLog => 'モデル準備失敗';

  @override
  String get speechStartFailedLog => '録音開始失敗';

  @override
  String get speechInterruptedLog => '録音中断';

  @override
  String get runtimeLog => '動作状況';

  @override
  String get success => '成功';

  @override
  String get reopen => '再試行';

  @override
  String get microphonePermission => 'マイクを使用して、音声を端末内で文字に変換します。';

  @override
  String seconds(int count) {
    return '$count 秒';
  }

  @override
  String segmentCount(int count) {
    return '$count 区間';
  }

  @override
  String downloadProgress(int percent) {
    return 'ダウンロード中 $percent%';
  }

  @override
  String analysisEvery(int seconds) {
    return '$seconds 秒ごとに新しいテキストを確認';
  }

  @override
  String focusTemplate(String name) {
    return '分析対象：$name';
  }

  @override
  String waitingBatches(int count) {
    return '$count 件の処理待ち・録音は続けられます';
  }

  @override
  String openQuestions(String questions) {
    return '確認事項：$questions';
  }

  @override
  String modelsFetched(int count) {
    return '接続しました。$count 件のモデルを取得しました。';
  }

  @override
  String selectedTemplate(String name) {
    return '選択済み：$name';
  }

  @override
  String editingTemplate(String name) {
    return '編集：$name';
  }

  @override
  String retryAttempt(int count) {
    return '試行 $count 回目';
  }

  @override
  String deleteModelTitle(String name) {
    return '$name を削除しますか？';
  }

  @override
  String modelStatus(String name, String status) {
    return '$name・$status';
  }

  @override
  String message(String code) {
    String _temp0 = intl.Intl.selectLogic(code, {
      'operationFailed': '操作を完了できませんでした。状態を確認して再試行してください。',
      'storageUnavailable': 'ローカルデータを開けません。端末の空き容量を確認してください。',
      'engineUnavailable': '音声エンジンを利用できません。iOS または Android 版をご利用ください。',
      'finishBeforeModelChange': 'モデルの読み込みや切り替えの前に録音を終了してください。',
      'finishRecordingFirst': '先に現在の録音を終了してください。',
      'modelPrepareFailed': 'モデルの準備に失敗しました。接続と空き容量を確認して再試行してください。',
      'modelDeleteFailed': 'モデルを削除できませんでした。端末のストレージを確認して再試行してください。',
      'downloadModelFirst': '先に設定画面でオフラインモデルをダウンロードして準備してください。',
      'speechStartFailed': '録音を開始できません。マイクの許可とモデルの状態を確認してください。',
      'speechInterrupted': '録音が中断されました。確定したテキストは保持されています。',
      'audioInterrupted': 'システムにより音声が中断されました。確定したテキストは保持されています。終了してから再開してください。',
      'speechProcessingPaused':
          '音声処理を一時停止しました。空き容量を確認するか Small に切り替えてください。確定したテキストは保持されています。',
      'transcriptSaveFailed':
          'テキストを保存できませんでした。空き容量を確認してください。ネイティブ側の記録は次回起動時に復元されます。',
      'speechStopFailed': '終了処理を完了できませんでした。確定したテキストは保持されています。',
      'schedulingFailed': '分析を開始できません。文字起こしは引き続き保存されます。',
      'unsupportedInterval': '対応していない分析間隔です。',
      'unsupportedLocale': '対応していない表示言語です。',
      'unsupportedAnalysisLanguage': '対応していない分析の出力言語です。',
      'configurationClearFailed': '設定を消去できません。システムの安全なストレージを利用できるか確認してください。',
      'enterApiKey': 'このプロバイダーの API キーを入力してください。',
      'invalidTemplate': 'テンプレート名と 4,000 文字以内の分析ルールを入力してください。',
      'invalidEndpoint': '認証情報やクエリパラメーターを含まない有効な HTTPS URL を指定してください。',
      'enterModelId': 'モデル ID を選択または入力してください。',
      'budgetTooSmall': 'モデルの入力または出力の上限が小さすぎます。',
      'invalidRulesLength': '分析ルールは 1〜4,000 文字で入力してください。',
      'rulesOverBudget': '分析ルールが入力の上限を超えています。',
      'segmentOverBudget': '文字起こしの区間が入力の上限を超えています。',
      'transcriptOverBudget': '文字起こし全体がモデルの入力上限を超えているため、一度に分析できません。',
      'nothingToAnalyze': 'この記録にはまだ分析できるテキストがありません。',
      'queueFull': '分析キューがいっぱいです。原文は保持されています。未完了のタスクを処理して再試行してください。',
      'saveApiKey': '設定画面で API キーを保存してください。',
      'analysisIncomplete': '分析が完了していません。診断ログを確認してください。',
      'invalidAnalysisResult': 'モデルの出力形式または原文の参照が無効です。手動で再試行できます。',
      'responseTooLarge': 'プロバイダーの応答が大きすぎます。',
      'analysisTimeout': '分析がタイムアウトしました。後で自動的に再試行します。',
      'invalidCredentials': 'キーが無効か、このモデルの利用権限がありません。設定を確認してください。',
      'insufficientBalance': 'プロバイダーの残高が不足しています。対応後に再試行してください。',
      'rateLimited': 'プロバイダーの利用制限に達しました。後で自動的に再試行します。',
      'providerUnavailable': 'プロバイダーを一時的に利用できません。後で自動的に再試行します。',
      'invalidRequest': '非対応の URL、モデル、またはパラメーターです。設定を確認してください。',
      'analysisPaused': '分析を一時停止しました。',
      'invalidCertificate': 'プロバイダーへの安全な接続を検証できません。',
      'unparseableResponse': 'プロバイダーの応答を解析できません。',
      'networkInterrupted': 'ネットワーク接続が中断されました。後で自動的に再試行します。',
      'responseContractMismatch': 'プロバイダーの応答が API の形式と一致しません。',
      'emptyResponse': 'プロバイダーから有効な分析結果が返されませんでした。',
      'incompleteOutput': 'モデルの出力が途中で終了しました。出力の上限を確認して再試行してください。',
      'noProviderModels': 'モデルが返されませんでした。モデル ID を手動で入力できます。',
      'fetchModelsFailed': 'モデルを取得できません。設定を確認するか、モデル ID を手動で入力してください。',
      'configurationSaveFailed': '設定を保存できません。システムの安全なストレージを利用できるか確認してください。',
      'finishBeforeDictation': '会話の録音を終了してからテンプレートを音声入力してください。',
      'saveTemplateFailed': 'テンプレートを保存できませんでした。再試行してください。',
      'analysisNeedsRetry': '一部の分析に再試行が必要です。録音には影響しません。',
      'logsUnavailable': 'ログを読み込めません。録音と文字起こしには影響しません。',
      'recordingOperationBusy': '記録を処理中です。しばらくお待ちください。',
      'recordingNotFound': 'この記録は存在しません。記録一覧に戻ってください。',
      'invalidRecordingTitle': '記録名を 1〜80 文字で入力してください。',
      'recordingOpenFailed': '記録を開けませんでした。再試行してください。',
      'recordingListFailed': '記録一覧を読み込めません。下に引いて更新するか再試行してください。',
      'createNewRecordingFirst': 'この録音は終了しています。新しい録音を作成してください。',
      'chooseRecordingFirst': '先に記録を開くか、新しい録音を作成してください。',
      'modelLoadFailed':
          'モデルはダウンロード済みですが読み込めませんでした。再読み込みするか Small に切り替えてください。再ダウンロードは不要です。',
      'other': '操作を完了できませんでした。状態を確認して再試行してください。',
    });
    return '$_temp0';
  }

  @override
  String get deletingModel => 'モデルを削除中…';

  @override
  String get modelDeleteFailedLog => 'モデル削除失敗';

  @override
  String diagnosticKind(String kind) {
    String _temp0 = intl.Intl.selectLogic(kind, {
      'network': 'ネットワーク',
      'timeout': 'タイムアウト',
      'rateLimited': '利用制限',
      'server': 'プロバイダーのサービス',
      'credentials': 'キー・権限',
      'balance': 'プロバイダーの残高',
      'invalidRequest': 'リクエスト設定',
      'invalidResponse': '応答内容',
      'storage': 'ローカルストレージ',
      'speech': '音声エンジン',
      'cancelled': '一時停止',
      'storage_or_configuration': 'ストレージ・設定',
      'other': '動作状況',
    });
    return '$_temp0';
  }

  @override
  String get latestTranscript => '最新のテキストへ';

  @override
  String get recordings => '記録';

  @override
  String get newRecording => '新しい録音';

  @override
  String get returnToRecording => '録音に戻る';

  @override
  String get analysisLanguage => '分析の出力言語';

  @override
  String get clearProviderConfiguration => '設定を消去';

  @override
  String get clearProviderTitle => 'プロバイダー設定を消去しますか？';

  @override
  String get clearProviderBody =>
      'API キーをシステムの安全なストレージから削除し、プロバイダーとモデルの設定をリセットします。分析が有効な記録は、設定を再保存するまで一時停止します。';

  @override
  String get providerConfigurationCleared => 'プロバイダー設定を消去しました';

  @override
  String get noRecordings => '録音はまだありません';

  @override
  String get noMatchingRecordings => '一致する記録がありません';

  @override
  String get searchRecordings => 'タイトル・本文を検索';

  @override
  String get clearSearch => '検索をクリア';

  @override
  String get loadMoreRecordings => 'さらに読み込む';

  @override
  String get recordingActions => '記録の操作';

  @override
  String get resumeRecording => '録音を続ける';

  @override
  String get finishRecordingBeforeResume => '先に現在の録音を終了してから続けてください';

  @override
  String get renameRecording => '名前を変更';

  @override
  String get recordingName => '記録名';

  @override
  String get saveRecordingName => '名前を保存';

  @override
  String get copyTranscript => '全文をコピー';

  @override
  String get noTranscriptToCopy => 'この記録には確定したテキストがありません';

  @override
  String get transcriptCopied => '全文をコピーしました';

  @override
  String get deleteRecording => '記録を削除';

  @override
  String get deleteRecordingBody =>
      'この記録のテキスト、分析結果、復元用ファイルを完全に削除します。ダウンロード済みモデルは保持されます。';

  @override
  String get finishRecordingBeforeDelete => '先に現在の録音を終了してください';

  @override
  String get recordingInterrupted => '中断';

  @override
  String get recoveredRecordingNotice =>
      '前回の録音が中断されました。確定したテキストは復元済みです。内容を確認するか、新しく録音できます。';

  @override
  String get noConfirmedTranscript => 'この記録には確定したテキストがありません';

  @override
  String get recordBeforeAnalysis => '録音を開始すると、この記録のオンライン分析を設定できます';

  @override
  String get transcriptTab => '文字起こし';

  @override
  String get localModelLoading => '端末内のモデルを読み込み';

  @override
  String get downloadModelToStart => 'モデルは初回にダウンロードすれば、繰り返しオフラインで使用できます';

  @override
  String recordingDateTitle(String date) {
    return '録音 $date';
  }

  @override
  String deleteRecordingTitle(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String savedRecordingDuration(String duration) {
    return '保存済み・$duration';
  }

  @override
  String pausedAnalysisBatches(int count) {
    return '$count 件の分析を一時停止中';
  }

  @override
  String get recognitionPreview => '認識中 · まだ確定していません';
}
