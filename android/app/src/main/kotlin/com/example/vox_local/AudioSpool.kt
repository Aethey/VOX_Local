package com.example.vox_local

import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import kotlinx.coroutines.*
import java.io.File
import java.io.RandomAccessFile
import java.nio.ByteBuffer
import java.nio.ByteOrder
import kotlin.math.sqrt

internal class AudioSpool(val file: File, private val scope: CoroutineScope) {
    @Volatile var count = 0; private set
    @Volatile var lastVoice = 0; private set
    @Volatile var level = 0.0; private set
    @Volatile var failure: Throwable? = null; private set
    @Volatile private var active = false
    private var reader: AudioRecord? = null
    private var job: Job? = null
    @Suppress("MissingPermission")
    fun start() {
        val min = AudioRecord.getMinBufferSize(16000, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT)
        check(min > 0)
        val record = AudioRecord(MediaRecorder.AudioSource.VOICE_RECOGNITION, 16000, AudioFormat.CHANNEL_IN_MONO, AudioFormat.ENCODING_PCM_16BIT, maxOf(min * 4, 16384))
        check(record.state == AudioRecord.STATE_INITIALIZED)
        reader = record; active = true
        record.startRecording()
        job = scope.launch(Dispatchers.IO) {
            try {
                RandomAccessFile(file, "rw").use { output ->
                    output.setLength(0)
                    val samples = ShortArray(2048)
                    while (active) {
                        val n = record.read(samples, 0, samples.size)
                        if (n <= 0) { if (!active) break; error("audio_capture_failed") }
                        check((count.toLong() + n) * 4 <= 256L * 1024 * 1024) { "audio_capacity" }
                        val data = ByteBuffer.allocate(n * 4).order(ByteOrder.LITTLE_ENDIAN)
                        var energy = 0.0
                        for (i in 0 until n) { val sample = samples[i] / 32768f; data.putFloat(sample); energy += sample * sample }
                        output.write(data.array())
                        count += n
                        val rms = sqrt(energy / n)
                        if (rms > 0.008) lastVoice = count
                        level = (rms * 12).coerceIn(0.0, 1.0)
                    }
                    output.fd.sync()
                }
            } catch (e: Throwable) { failure = e; active = false }
        }
    }
    suspend fun stop() {
        active = false
        try { reader?.stop() } catch (_: IllegalStateException) {}
        job?.join(); reader?.release(); reader = null; job = null
    }
    fun read(offset: Int, length: Int): FloatArray = RandomAccessFile(file, "r").use { input ->
        input.seek(offset.toLong() * 4)
        val bytes = ByteArray(length * 4); input.readFully(bytes)
        val buffer = ByteBuffer.wrap(bytes).order(ByteOrder.LITTLE_ENDIAN)
        FloatArray(length) { buffer.float }
    }
}
