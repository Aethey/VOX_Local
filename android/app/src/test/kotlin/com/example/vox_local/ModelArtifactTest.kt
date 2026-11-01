package com.example.vox_local

import org.junit.Assert.*
import org.junit.Test
import java.io.File
import java.security.MessageDigest

class ModelArtifactTest {
    @Test fun corruptionAndTruncationAreRejected() {
        val fixture = File.createTempFile("vox-model", ".fixture")
        try {
            val bytes = "synthetic fixture".toByteArray()
            val sha = MessageDigest.getInstance("SHA-256").digest(bytes).joinToString("") { "%02x".format(it) }
            val artifact = ModelArtifact("fixture", bytes.size.toLong(), sha)
            fixture.writeBytes(bytes); assertTrue(artifact.verify(fixture))
            fixture.writeText("synthetic fixturE"); assertFalse(artifact.verify(fixture))
            fixture.writeText("short"); assertFalse(artifact.verify(fixture))
        } finally { fixture.delete() }
    }
}
