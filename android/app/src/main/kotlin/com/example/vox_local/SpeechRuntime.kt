package com.example.vox_local

import android.content.Context
import android.net.ConnectivityManager
import android.net.Network
import android.net.NetworkCapabilities
import io.flutter.plugin.common.BinaryMessenger
import kotlinx.coroutines.*
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import org.json.JSONObject
import java.io.File
import java.net.URL
import java.security.MessageDigest

internal object WhisperNative {
    init { System.loadLibrary("vox_speech") }
    external fun load(path: String): Long
    external fun release(pointer: Long)
    external fun cancel(pointer: Long)
    external fun transcribe(pointer: Long, samples: FloatArray, language: String, threads: Int): Array<String>
}

internal class SpeechRuntime(private val context: Context, messenger: BinaryMessenger, private val permission: suspend () -> Boolean) : SpeechHostApi {
    private val flutter = SpeechFlutterApi(messenger)
    private val root = File(context.noBackupFilesDir, "speech").apply { mkdirs() }
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Default)
    private val mutex = Mutex()
    private var pointer = 0L
    private var selected: String? = null
    private var capture: AudioSpool? = null
    private var process: Job? = null
    @Volatile private var stopping = false
    private val connectivity = context.getSystemService(ConnectivityManager::class.java)
    private fun online(): Boolean = connectivity.getNetworkCapabilities(connectivity.activeNetwork)?.hasCapability(NetworkCapabilities.NET_CAPABILITY_VALIDATED) == true
    private val networkCallback = object : ConnectivityManager.NetworkCallback() {
        override fun onAvailable(network: Network) { scope.launch { emitNetwork() } }
        override fun onLost(network: Network) { scope.launch { emitNetwork() } }
        override fun onCapabilitiesChanged(network: Network, capabilities: NetworkCapabilities) { scope.launch { emitNetwork() } }
    }
    init { connectivity.registerDefaultNetworkCallback(networkCallback) }
    private suspend fun emitNetwork() { emit(NativeEvent(kind = "network", phase = if (online()) "online" else "offline")) }

    private data class Model(val file: String, val size: Long, val sha: String)
    private fun model(id: String): Model = when (id) {
        "turbo" -> Model("ggml-large-v3-turbo-q5_0.bin", 574041195, "394221709cd5ad1f40c46e6031ca61bce88931e6e088c188294c6d5a55ffa7e2")
        "small" -> Model("ggml-small-q5_1.bin", 190085487, "ae85e4a935d7a567bd102fe55afc16bb595bdb618e11b2fc7591bc08120411bb")
        else -> error("unknown_model")
    }
    private suspend fun emit(event: NativeEvent) { withContext(Dispatchers.Main) { try { flutter.onEvent(event) } catch (_: Exception) {} } }
    override suspend fun models(): List<NativeModel> = withContext(Dispatchers.IO) { emitNetwork(); listOf("turbo", "small").map { id -> NativeModel(id, File(root, model(id).file).length() == model(id).size) } }
    override suspend fun download(modelId: String) = mutex.withLock { withContext(Dispatchers.IO) {
        check(capture == null)
        val item = model(modelId)
        val part = File(root, item.file + ".part")
        if (part.length() > item.size) part.delete()
        var offset = part.length()
        val connection = URL("https://huggingface.co/ggerganov/whisper.cpp/resolve/5359861c739e955e79d9a303bcbc70fb988958b1/${item.file}").openConnection() as java.net.HttpURLConnection
        connection.connectTimeout = 15000; connection.readTimeout = 30000
        if (offset > 0) connection.setRequestProperty("Range", "bytes=$offset-")
        try {
            connection.connect()
            check(connection.responseCode in listOf(200, 206))
            if (connection.responseCode == 200) offset = 0
            val digest = MessageDigest.getInstance("SHA-256")
            if (offset > 0) part.inputStream().use { input -> val buffer = ByteArray(65536); while (true) { val n = input.read(buffer); if (n < 0) break; digest.update(buffer, 0, n) } }
            java.io.FileOutputStream(part, offset > 0).use { output ->
                connection.inputStream.use { input ->
                    val buffer = ByteArray(65536); var last = 0L
                    while (true) {
                        val n = input.read(buffer); if (n < 0) break
                        offset += n; check(offset <= item.size)
                        output.write(buffer, 0, n); digest.update(buffer, 0, n)
                        val now = android.os.SystemClock.elapsedRealtime()
                        if (now - last > 250) { emit(NativeEvent(kind = "model", modelId = modelId, phase = "downloading", progress = offset.toDouble() / item.size)); last = now }
                    }
                }; output.fd.sync()
            }
            emit(NativeEvent(kind = "model", modelId = modelId, phase = "verifying"))
            val sha = digest.digest().joinToString("") { "%02x".format(it) }
            if (offset != item.size || sha != item.sha) { part.delete(); error("model_checksum_failed") }
            check(part.renameTo(File(root, item.file)))
            emit(NativeEvent(kind = "model", modelId = modelId, phase = "installed", progress = 1.0))
        } finally { connection.disconnect() }
    } }
    override suspend fun load(modelId: String) = mutex.withLock { withContext(Dispatchers.Default) {
        check(capture == null)
        if (selected == modelId && pointer != 0L) return@withContext
        if (pointer != 0L) WhisperNative.release(pointer)
        pointer = 0; selected = null
        val item = model(modelId); val path = File(root, item.file)
        check(ModelArtifact(item.file, item.size, item.sha).verify(path))
        pointer = WhisperNative.load(path.absolutePath); check(pointer != 0L)
        selected = modelId
    } }
    override suspend fun delete(modelId: String) = mutex.withLock { withContext(Dispatchers.IO) {
        check(capture == null)
        if (selected == modelId) { WhisperNative.release(pointer); pointer = 0; selected = null }
        for (file in listOf(File(root, model(modelId).file), File(root, model(modelId).file + ".part"))) {
            check(!file.exists() || file.delete()) { "model_delete_failed" }
        }
        Unit
    } }
    override suspend fun start(sessionId: String, language: String, afterSequence: Long, offset: Double) = mutex.withLock {
        check(pointer != 0L && capture == null && sessionId.matches(Regex("[0-9-]{1,100}")))
        check(afterSequence >= 0 && offset.isFinite() && offset >= 0)
        check(permission()) { "microphone_permission" }
        val spool = AudioSpool(File(root, "$sessionId.pcm"), scope)
        withContext(Dispatchers.IO) { spool.start() }
        capture = spool; stopping = false
        process = scope.launch { processAudio(spool, sessionId, language, afterSequence, offset) }
    }
    private suspend fun processAudio(spool: AudioSpool, sessionId: String, language: String, afterSequence: Long, offset: Double) {
        // A resumed session keeps numbering and time continuous with stored segments.
        var cursor = 0; var previous = 0; var sequence = afterSequence; var revision = 0L
        try {
            while (currentCoroutineContext().isActive) {
                spool.failure?.let { throw it }
                val total = spool.count
                emit(NativeEvent(kind = "level", sessionId = sessionId, level = spool.level))
                val available = total - cursor
                if (available <= 0) { if (stopping) break; delay(250); continue }
                if (spool.lastVoice <= cursor) { cursor = total; if (stopping) break; delay(250); continue }
                // Freeze finality before inference; a stop received mid-decode needs a fresh final pass.
                val window = TranscriptionWindow.next(cursor, total, spool.lastVoice, previous, stopping)
                if (window == null) { delay(250); continue }
                val audio = withContext(Dispatchers.IO) { spool.read(window.start, window.decoderEnd - window.start) }
                previous = total
                val text = WhisperNative.transcribe(pointer, audio, language, (Runtime.getRuntime().availableProcessors() - 2).coerceIn(1, 4))
                    .mapNotNull { line -> line.split('\t', limit = 3).takeIf { it.size == 3 }?.get(2) }
                    .joinToString("").trim()
                revision++
                if (window.isFinal) {
                    val committed = mutableListOf<NativeSegment>()
                    if (text.isNotEmpty()) {
                        sequence++
                        val item = NativeSegment(sessionId, sequence, offset + window.start / 16000.0, offset + window.end / 16000.0, text)
                        withContext(Dispatchers.IO) {
                            val json = JSONObject().put("sessionId", sessionId).put("sequence", sequence).put("start", item.start).put("end", item.end).put("text", item.text)
                            java.io.FileOutputStream(File(root, "$sessionId.jsonl"), true).use { out -> out.write((json.toString() + "\n").toByteArray()); out.fd.sync() }
                        }
                        committed.add(item)
                    }
                    cursor = window.end
                    emit(NativeEvent(kind = "transcript", sessionId = sessionId, text = "", segments = committed, revision = revision))
                } else {
                    emit(NativeEvent(kind = "transcript", sessionId = sessionId, text = text, segments = emptyList(), revision = revision))
                }
            }
            spool.file.delete()
        } catch (_: Exception) {
            spool.stop(); stopping = true
            emit(NativeEvent(kind = "error", sessionId = sessionId, text = "speechProcessingPaused"))
        }
    }
    override suspend fun stop() = mutex.withLock {
        withContext(Dispatchers.IO) { capture?.stop() }; stopping = true
        process?.join(); process = null; capture = null
    }
    override suspend fun deleteSession(sessionId: String) = withContext(Dispatchers.IO) {
        check(capture == null && sessionId.matches(Regex("[0-9-]{1,100}")))
        for (file in listOf(File(root, "$sessionId.jsonl"), File(root, "$sessionId.pcm"))) {
            check(!file.exists() || file.delete()) { "recording_delete_failed" }
        }
        Unit
    }
    override suspend fun replay(sessionId: String, afterSequence: Long): List<NativeSegment> = withContext(Dispatchers.IO) {
        check(sessionId.matches(Regex("[0-9-]{1,100}")))
        val file = File(root, "$sessionId.jsonl")
        if (!file.exists()) return@withContext emptyList()
        file.useLines { lines -> lines.mapNotNull { line ->
            try { val j = JSONObject(line); val seq = j.getLong("sequence"); if (seq <= afterSequence) null else NativeSegment(sessionId, seq, j.getDouble("start"), j.getDouble("end"), j.getString("text")) } catch (_: Exception) { null }
        }.take(200).toList() }
    }
    fun dispose() { connectivity.unregisterNetworkCallback(networkCallback); scope.launch { stop(); if (pointer != 0L) { WhisperNative.release(pointer); pointer = 0 }; scope.cancel() } }
}
