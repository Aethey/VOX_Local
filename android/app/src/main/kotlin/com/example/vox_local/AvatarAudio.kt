package com.example.vox_local

import android.annotation.SuppressLint
import android.content.Context
import android.media.AudioAttributes
import android.media.AudioFocusRequest
import android.media.AudioFormat
import android.media.AudioManager
import android.media.AudioRecord
import android.media.AudioTrack
import android.media.MediaRecorder
import android.os.Build
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel
import kotlinx.coroutines.CancellationException
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.Job
import kotlinx.coroutines.SupervisorJob
import kotlinx.coroutines.cancel
import kotlinx.coroutines.cancelAndJoin
import kotlinx.coroutines.delay
import kotlinx.coroutines.isActive
import kotlinx.coroutines.launch
import kotlinx.coroutines.sync.Mutex
import kotlinx.coroutines.sync.withLock
import kotlinx.coroutines.withContext
import java.nio.ByteBuffer
import java.nio.ByteOrder
import kotlin.math.sqrt

internal class AvatarAudio(
    context: Context,
    messenger: BinaryMessenger,
    private val requestMicrophone: suspend () -> Boolean,
) : EventChannel.StreamHandler {
    private val methods = MethodChannel(messenger, "vox/avatar/audio")
    private val events = EventChannel(messenger, "vox/avatar/audio-events")
    private val scope = CoroutineScope(SupervisorJob() + Dispatchers.Main.immediate)
    private val controls = Mutex()
    private val audioManager = context.getSystemService(AudioManager::class.java)
    private var sink: EventChannel.EventSink? = null
    private var capture: Capture? = null
    private var playback: Playback? = null
    private var audioFocus: AudioFocusRequest? = null
    private var legacyFocus = false
    private val focusListener = AudioManager.OnAudioFocusChangeListener { change ->
        if (change < 0 && playback != null) {
            emitError("playbackInterrupted")
            scope.launch { controls.withLock { stopPlayback() } }
        }
    }

    init {
        events.setStreamHandler(this)
        methods.setMethodCallHandler { call, result ->
            if (call.method == "requestMicrophone") {
                scope.launch { result.success(requestMicrophone()) }
                return@setMethodCallHandler
            }
            scope.launch {
                try {
                    controls.withLock {
                        when (call.method) {
                            "startRecording" -> startRecording()
                            "stopRecording" -> stopRecording()
                            "startPlayback" -> startPlayback()
                            "writePlayback" -> writePlayback(call.arguments as ByteArray)
                            "finishPlayback" -> requireNotNull(playback).finished = true
                            "stop" -> stopAudio()
                            else -> {
                                result.notImplemented()
                                return@launch
                            }
                        }
                    }
                    result.success(null)
                } catch (error: CancellationException) {
                    throw error
                } catch (error: Exception) {
                    Log.w(TAG, call.method, error)
                    result.error("audioUnavailable", call.method, null)
                }
            }
        }
    }

    override fun onListen(arguments: Any?, eventSink: EventChannel.EventSink) {
        sink = eventSink
    }

    override fun onCancel(arguments: Any?) {
        sink = null
        stop()
    }

    fun stop() {
        scope.launch { controls.withLock { stopAudio() } }
    }

    fun dispose() {
        methods.setMethodCallHandler(null)
        events.setStreamHandler(null)
        sink = null
        scope.launch {
            controls.withLock { stopAudio() }
            scope.cancel()
        }
    }

    private suspend fun stopAudio() {
        stopRecording()
        stopPlayback()
    }

    @SuppressLint("MissingPermission")
    private fun startRecording() {
        check(capture == null && playback == null)
        val minimum = AudioRecord.getMinBufferSize(
            SAMPLE_RATE,
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT,
        )
        check(minimum > 0)
        val recorder = AudioRecord(
            MediaRecorder.AudioSource.VOICE_RECOGNITION,
            SAMPLE_RATE,
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT,
            maxOf(minimum * 2, CAPTURE_FRAMES * 4),
        )
        try {
            check(recorder.state == AudioRecord.STATE_INITIALIZED)
            recorder.startRecording()
            check(recorder.recordingState == AudioRecord.RECORDSTATE_RECORDING)
        } catch (error: Exception) {
            recorder.release()
            throw error
        }
        val current = Capture(recorder)
        capture = current
        current.job = scope.launch(Dispatchers.IO) {
            val samples = ShortArray(CAPTURE_FRAMES)
            try {
                while (isActive && current.running) {
                    val count = recorder.read(samples, 0, samples.size, AudioRecord.READ_BLOCKING)
                    if (count <= 0 && !current.running) break
                    check(count > 0)
                    val bytes = ByteBuffer.allocate(count * 2).order(ByteOrder.LITTLE_ENDIAN)
                    for (index in 0 until count) bytes.putShort(samples[index])
                    withContext(Dispatchers.Main.immediate) {
                        if (capture === current) sink?.success(bytes.array())
                    }
                }
            } catch (error: CancellationException) {
                throw error
            } catch (error: Exception) {
                withContext(Dispatchers.Main.immediate) {
                    if (capture === current && current.running) emitError("captureFailed")
                }
            }
        }
    }

    private suspend fun stopRecording() {
        val current = capture ?: return
        current.running = false
        runCatching { current.recorder.stop() }
        current.job.join()
        current.recorder.release()
        capture = null
    }

    @Suppress("DEPRECATION")
    private fun startPlayback() {
        check(capture == null && playback == null)
        val attributes = AudioAttributes.Builder()
            .setUsage(AudioAttributes.USAGE_MEDIA)
            .setContentType(AudioAttributes.CONTENT_TYPE_SPEECH)
            .build()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val request = AudioFocusRequest.Builder(AudioManager.AUDIOFOCUS_GAIN_TRANSIENT)
                .setAudioAttributes(attributes)
                .setOnAudioFocusChangeListener(focusListener)
                .build()
            check(audioManager.requestAudioFocus(request) == AudioManager.AUDIOFOCUS_REQUEST_GRANTED)
            audioFocus = request
        } else {
            check(audioManager.requestAudioFocus(
                focusListener,
                AudioManager.STREAM_MUSIC,
                AudioManager.AUDIOFOCUS_GAIN_TRANSIENT,
            ) == AudioManager.AUDIOFOCUS_REQUEST_GRANTED)
            legacyFocus = true
        }
        val minimum = AudioTrack.getMinBufferSize(
            SAMPLE_RATE,
            AudioFormat.CHANNEL_OUT_MONO,
            AudioFormat.ENCODING_PCM_16BIT,
        )
        var track: AudioTrack? = null
        try {
            check(minimum > 0)
            track = AudioTrack.Builder()
                .setAudioAttributes(attributes)
                .setAudioFormat(AudioFormat.Builder()
                    .setEncoding(AudioFormat.ENCODING_PCM_16BIT)
                    .setSampleRate(SAMPLE_RATE)
                    .setChannelMask(AudioFormat.CHANNEL_OUT_MONO)
                    .build())
                .setTransferMode(AudioTrack.MODE_STREAM)
                .setBufferSizeInBytes(maxOf(minimum, START_FRAMES * 2))
                .build()
            check(track.state == AudioTrack.STATE_INITIALIZED)
            val current = Playback(track)
            playback = current
            current.job = scope.launch { play(current) }
        } catch (error: Exception) {
            track?.release()
            releaseFocus()
            throw error
        }
    }

    private fun writePlayback(bytes: ByteArray) {
        val current = requireNotNull(playback)
        check(!current.finished && bytes.isNotEmpty() && bytes.size % 2 == 0)
        check(current.pendingFrames + bytes.size / 2 <= MAX_PENDING_FRAMES)
        val samples = ShortArray(bytes.size / 2)
        ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN).asShortBuffer().get(samples)
        current.pending.addLast(samples)
        current.pendingFrames += samples.size
    }

    private suspend fun play(current: Playback) {
        val track = current.track
        var started = false
        var announced = false
        var lastHead = 0
        var lastLevel = 0.0
        var smoothed = 0.0
        var lastAdvance = 0L
        var written = 0
        val envelope = ArrayDeque<Level>()
        try {
            while (scope.isActive && playback === current) {
                // Poll with nonblocking writes so stop can flush immediately.
                val next = current.pending.firstOrNull()
                if (next != null) {
                    val count = track.write(
                        next,
                        current.offset,
                        minOf(next.size - current.offset, WRITE_FRAMES),
                        AudioTrack.WRITE_NON_BLOCKING,
                    )
                    check(count >= 0)
                    if (count > 0) {
                        val end = current.offset + count
                        for (start in current.offset until end step LEVEL_FRAMES) {
                            val limit = minOf(start + LEVEL_FRAMES, end)
                            var squares = 0.0
                            for (index in start until limit) {
                                val value = next[index] / 32768.0
                                squares += value * value
                            }
                            written += limit - start
                            envelope.addLast(Level(written, sqrt(squares / (limit - start))))
                        }
                        current.pendingFrames -= count
                        current.offset = end
                        if (end == next.size) {
                            current.pending.removeFirst()
                            current.offset = 0
                        }
                    }
                }
                if (!started && written > 0 &&
                    (written >= START_FRAMES || current.finished)
                ) {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        track.startThresholdInFrames = minOf(written, track.bufferSizeInFrames)
                    }
                    track.play()
                    started = true
                    lastAdvance = android.os.SystemClock.elapsedRealtime()
                }
                val head = track.playbackHeadPosition
                if (head > lastHead) {
                    if (!announced) {
                        sink?.success(mapOf("type" to "playing"))
                        announced = true
                    }
                    while (envelope.isNotEmpty() && envelope.first().endFrame <= head) {
                        lastLevel = envelope.removeFirst().rms
                    }
                    lastLevel = envelope.firstOrNull()?.rms ?: lastLevel
                    lastAdvance = android.os.SystemClock.elapsedRealtime()
                } else if (started && head < written &&
                    android.os.SystemClock.elapsedRealtime() - lastAdvance > 4_000
                ) {
                    error("AudioTrack stalled")
                }
                if (announced) {
                    val target = if (head > lastHead) {
                        ((lastLevel - 0.008) * 9.0).coerceIn(0.0, 1.0)
                    } else {
                        0.0
                    }
                    smoothed += (target - smoothed) * if (target > smoothed) 0.7 else 0.45
                    sink?.success(mapOf("type" to "level", "value" to smoothed))
                }
                lastHead = head
                if (current.finished && current.pending.isEmpty() && head >= written) {
                    finishTrack(current)
                    sink?.success(mapOf("type" to "drained"))
                    return
                }
                delay(if (next != null && !started) 5 else 12)
            }
        } catch (error: CancellationException) {
            throw error
        } catch (error: Exception) {
            Log.w(TAG, "streaming playback", error)
            if (playback === current) {
                finishTrack(current)
                emitError("playbackFailed")
            }
        }
    }

    private suspend fun stopPlayback() {
        val current = playback ?: return
        current.job.cancelAndJoin()
        finishTrack(current)
    }

    private fun finishTrack(current: Playback) {
        playback = null
        runCatching { current.track.pause() }
        runCatching { current.track.flush() }
        current.track.release()
        releaseFocus()
    }

    @Suppress("DEPRECATION")
    private fun releaseFocus() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            audioFocus?.let { audioManager.abandonAudioFocusRequest(it) }
        } else if (legacyFocus) {
            audioManager.abandonAudioFocus(focusListener)
        }
        audioFocus = null
        legacyFocus = false
    }

    private fun emitError(code: String) {
        sink?.success(mapOf("type" to "error", "code" to code))
    }

    private class Capture(val recorder: AudioRecord) {
        @Volatile var running = true
        lateinit var job: Job
    }

    private class Playback(val track: AudioTrack) {
        val pending = ArrayDeque<ShortArray>()
        var pendingFrames = 0
        var offset = 0
        var finished = false
        lateinit var job: Job
    }

    private data class Level(val endFrame: Int, val rms: Double)

    private companion object {
        const val TAG = "AvatarAudio"
        const val SAMPLE_RATE = 24_000
        const val CAPTURE_FRAMES = 960
        const val START_FRAMES = 1_440
        const val LEVEL_FRAMES = 480
        const val WRITE_FRAMES = 960
        const val MAX_PENDING_FRAMES = SAMPLE_RATE * 30
    }
}
