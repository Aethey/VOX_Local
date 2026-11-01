package com.example.vox_local

/** An immutable physical range; decoder timestamps never advance the audio cursor. */
internal data class TranscriptionWindow(val start: Int, val end: Int, val decoderEnd: Int, val isFinal: Boolean) {
    companion object {
        const val SAMPLE_RATE = 16000
        const val MAXIMUM_SAMPLES = 20 * SAMPLE_RATE
        fun next(start: Int, count: Int, lastVoice: Int, lastDecoded: Int, stopped: Boolean): TranscriptionWindow? {
            if (count <= start || lastVoice <= start) return null
            val available = count - start
            val final = stopped || available >= MAXIMUM_SAMPLES || count - lastVoice >= 11200
            if (!final && (available < SAMPLE_RATE || count - lastDecoded < SAMPLE_RATE)) return null
            val end = start + minOf(available, MAXIMUM_SAMPLES)
            return TranscriptionWindow(start, end, minOf(end, lastVoice + 4800), final)
        }
    }
}
