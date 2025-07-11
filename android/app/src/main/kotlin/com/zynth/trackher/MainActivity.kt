package com.zynth.trackher

import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    companion object{
        private const val CHANNEL = "com.zynth.trackher/info"
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when(call.method) {
                "getInstallDate" -> {
                    val installDate = NativeUtils.getAppInstallationDate(this)
                    if (installDate > 0) result.success(installDate) else result.error("UNAVAILABLE", "Install date not available.", null)
                }
                "getBatteryLevel" -> {
                    val level = NativeUtils.getBatteryLevel(this)
                    if (level >= 0) result.success(level) else result.error("UNAVAILABLE", "Battery level unavailable", null)
                }
                "getOsVersion" -> {
                    result.success(NativeUtils.getOsVersion())
                }
                "getAppVersion" -> {
                    val version = NativeUtils.getVersion(this)
                    if (version.isNotEmpty()) result.success(version) else result.error("UNAVAILABLE", "App Version unavailable", null)
                }
                "isWifiConnected" -> {
                    result.success(NativeUtils.isWifiConnected(this))
                }
                else -> result.notImplemented()
            }
        }
    }
}

