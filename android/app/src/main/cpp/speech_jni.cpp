#include <jni.h>
#include <whisper.h>
#include <atomic>
#include <algorithm>
#include <string>
#include <vector>

struct Engine { whisper_context* ctx; std::atomic<bool> cancelled{false}; };
extern "C" JNIEXPORT jlong JNICALL Java_com_example_vox_1local_WhisperNative_load(JNIEnv* env, jobject, jstring path) {
  const char* chars = env->GetStringUTFChars(path, nullptr);
  auto params = whisper_context_default_params(); params.use_gpu = false;
  auto* ctx = whisper_init_from_file_with_params(chars, params);
  env->ReleaseStringUTFChars(path, chars);
  return ctx ? reinterpret_cast<jlong>(new Engine{ctx}) : 0;
}
extern "C" JNIEXPORT void JNICALL Java_com_example_vox_1local_WhisperNative_release(JNIEnv*, jobject, jlong pointer) {
  auto* engine = reinterpret_cast<Engine*>(pointer);
  if (engine) { whisper_free(engine->ctx); delete engine; }
}
extern "C" JNIEXPORT void JNICALL Java_com_example_vox_1local_WhisperNative_cancel(JNIEnv*, jobject, jlong pointer) {
  auto* engine = reinterpret_cast<Engine*>(pointer);
  if (engine) engine->cancelled = true;
}
extern "C" JNIEXPORT jobjectArray JNICALL Java_com_example_vox_1local_WhisperNative_transcribe(JNIEnv* env, jobject, jlong pointer, jfloatArray input, jstring language, jint threads) {
  auto* engine = reinterpret_cast<Engine*>(pointer);
  if (!engine) return nullptr;
  engine->cancelled = false;
  auto* samples = env->GetFloatArrayElements(input, nullptr);
  const char* lang = env->GetStringUTFChars(language, nullptr);
  auto params = whisper_full_default_params(WHISPER_SAMPLING_GREEDY);
  params.n_threads = std::max(1, std::min(4, static_cast<int>(threads)));
  params.language = std::string(lang) == "auto" ? "auto" : lang;
  params.translate = false; params.no_context = true;
  params.print_progress = params.print_realtime = params.print_timestamps = params.print_special = false;
  params.suppress_blank = true; params.temperature_inc = 0.0f;
  params.abort_callback = [](void* data) { return reinterpret_cast<Engine*>(data)->cancelled.load(); };
  params.abort_callback_user_data = engine;
  const int status = whisper_full(engine->ctx, params, samples, env->GetArrayLength(input));
  env->ReleaseFloatArrayElements(input, samples, JNI_ABORT);
  env->ReleaseStringUTFChars(language, lang);
  if (status != 0) { env->ThrowNew(env->FindClass("java/lang/IllegalStateException"), "speech_inference_failed"); return nullptr; }
  const int count = whisper_full_n_segments(engine->ctx);
  auto result = env->NewObjectArray(count, env->FindClass("java/lang/String"), nullptr);
  for (int i = 0; i < count; ++i) {
    std::string line = std::to_string(whisper_full_get_segment_t0(engine->ctx, i)) + "\t" + std::to_string(whisper_full_get_segment_t1(engine->ctx, i)) + "\t" + whisper_full_get_segment_text(engine->ctx, i);
    // UTF-8 from Whisper is decoded by Java's charset decoder, not modified UTF-8 JNI.
    auto bytes = env->NewByteArray(static_cast<jsize>(line.size()));
    env->SetByteArrayRegion(bytes, 0, static_cast<jsize>(line.size()), reinterpret_cast<const jbyte*>(line.data()));
    auto stringClass = env->FindClass("java/lang/String");
    auto constructor = env->GetMethodID(stringClass, "<init>", "([BLjava/lang/String;)V");
    auto charset = env->NewStringUTF("UTF-8");
    auto text = env->NewObject(stringClass, constructor, bytes, charset);
    env->SetObjectArrayElement(result, i, text);
    env->DeleteLocalRef(text); env->DeleteLocalRef(charset); env->DeleteLocalRef(bytes); env->DeleteLocalRef(stringClass);
  }
  return result;
}
