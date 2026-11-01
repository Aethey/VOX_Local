package com.example.vox_local

import java.io.File
import java.security.MessageDigest

internal data class ModelArtifact(val filename: String, val bytes: Long, val sha256: String) {
    fun verify(file: File): Boolean {
        if (!file.isFile || file.length() != bytes) return false
        val digest = MessageDigest.getInstance("SHA-256")
        file.inputStream().use { input ->
            val buffer = ByteArray(65536)
            while (true) { val n = input.read(buffer); if (n < 0) break; digest.update(buffer, 0, n) }
        }
        return digest.digest().joinToString("") { "%02x".format(it) } == sha256
    }
}
