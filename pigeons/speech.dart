import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(
  PigeonOptions(
    dartOut: 'lib/infrastructure/generated/speech.g.dart',
    swiftOut: 'ios/Runner/Speech.g.swift',
    kotlinOut: 'android/app/src/main/kotlin/com/example/vox_local/Speech.g.kt',
    kotlinOptions: KotlinOptions(package: 'com.example.vox_local'),
  ),
)
class NativeModel {
  NativeModel({required this.id, required this.installed});
  String id;
  bool installed;
}

class NativeSegment {
  NativeSegment({
    required this.sessionId,
    required this.sequence,
    required this.start,
    required this.end,
    required this.text,
  });
  String sessionId;
  int sequence;
  double start;
  double end;
  String text;
}

class NativeEvent {
  NativeEvent({
    required this.kind,
    this.sessionId,
    this.modelId,
    this.phase,
    this.progress,
    this.text,
    this.level,
    this.segment,
    this.segments,
    this.revision,
  });
  String kind;
  String? sessionId;
  String? modelId;
  String? phase;
  double? progress;
  String? text;
  double? level;
  NativeSegment? segment;
  List<NativeSegment>? segments;
  int? revision;
}

@HostApi()
abstract class SpeechHostApi {
  @async
  List<NativeModel> models();
  @async
  void download(String modelId);
  @async
  void load(String modelId);
  @async
  void delete(String modelId);

  /// Resuming a session continues numbering after [afterSequence] and shifts
  /// timestamps by [offset] seconds so new segments follow the stored timeline.
  @async
  void start(
    String sessionId,
    String language,
    int afterSequence,
    double offset,
  );
  @async
  void stop();
  @async
  void deleteSession(String sessionId);
  @async
  List<NativeSegment> replay(String sessionId, int afterSequence);
}

@FlutterApi()
abstract class SpeechFlutterApi {
  void onEvent(NativeEvent event);
}
