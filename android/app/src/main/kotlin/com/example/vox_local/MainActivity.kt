package com.example.vox_local

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.Manifest
import android.content.pm.PackageManager
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

class MainActivity : FlutterActivity() {
    private var runtime: SpeechRuntime? = null
    private var avatarAudio: AvatarAudio? = null
    private var permissionReply: ((Boolean) -> Unit)? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val messenger = flutterEngine.dartExecutor.binaryMessenger
        runtime = SpeechRuntime(this, messenger, ::requestMicrophone)
        SpeechHostApi.setUp(messenger, runtime)
        avatarAudio = AvatarAudio(this, messenger, ::requestMicrophone)
    }

    private suspend fun requestMicrophone(): Boolean {
        if (checkSelfPermission(Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) {
            return true
        }
        if (permissionReply != null) return false
        return suspendCancellableCoroutine { continuation ->
            permissionReply = { granted ->
                if (continuation.isActive) continuation.resume(granted)
            }
            requestPermissions(arrayOf(Manifest.permission.RECORD_AUDIO), 501)
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 501) {
            val reply = permissionReply
            permissionReply = null
            reply?.invoke(grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED)
        }
    }

    override fun onStop() {
        avatarAudio?.stop()
        super.onStop()
    }

    override fun cleanUpFlutterEngine(flutterEngine: FlutterEngine) {
        permissionReply?.invoke(false)
        permissionReply = null
        avatarAudio?.dispose()
        avatarAudio = null
        SpeechHostApi.setUp(flutterEngine.dartExecutor.binaryMessenger, null)
        runtime?.dispose()
        runtime = null
        super.cleanUpFlutterEngine(flutterEngine)
    }
}
