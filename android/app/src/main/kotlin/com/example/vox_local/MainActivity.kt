package com.example.vox_local

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import android.Manifest
import android.content.pm.PackageManager
import kotlinx.coroutines.suspendCancellableCoroutine
import kotlin.coroutines.resume

class MainActivity : FlutterActivity() {
    private var runtime: SpeechRuntime? = null
    private var permissionReply: ((Boolean) -> Unit)? = null
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        runtime = SpeechRuntime(this, flutterEngine.dartExecutor.binaryMessenger) {
            if (checkSelfPermission(Manifest.permission.RECORD_AUDIO) == PackageManager.PERMISSION_GRANTED) true
            else suspendCancellableCoroutine { continuation ->
                permissionReply = { if (continuation.isActive) continuation.resume(it) }
                requestPermissions(arrayOf(Manifest.permission.RECORD_AUDIO), 501)
            }
        }
        SpeechHostApi.setUp(flutterEngine.dartExecutor.binaryMessenger, runtime)
    }
    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        if (requestCode == 501) { permissionReply?.invoke(grantResults.firstOrNull() == PackageManager.PERMISSION_GRANTED); permissionReply = null }
    }
    override fun onDestroy() { permissionReply?.invoke(false); permissionReply = null; runtime?.dispose(); super.onDestroy() }
}
