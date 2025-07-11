package com.zynth.trackher

import android.content.Context
import android.content.pm.PackageManager
import android.net.ConnectivityManager
import android.net.NetworkCapabilities
import android.os.BatteryManager
import android.os.Build
import android.util.Log
import com.zynth.trackher.utils.getAndroidOsName

object NativeUtils {
    fun getBatteryLevel(context: Context): Int {
        val bm = context.getSystemService(Context.BATTERY_SERVICE) as BatteryManager
        return bm.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }

    fun isWifiConnected(context: Context): Boolean {
        val cm = context.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        val nw = cm.activeNetwork ?: return false
        val caps = cm.getNetworkCapabilities(nw) ?: return false
        return caps.hasTransport(NetworkCapabilities.TRANSPORT_WIFI)
    }

    fun getAppInstallationDate(context: Context): Long {
        try {
            val packageInfo = context.packageManager.getPackageInfo(context.packageName, 0)
            return packageInfo.firstInstallTime
        } catch (e: PackageManager.NameNotFoundException) {
            return 0
        }
    }

    fun getVersion(context: Context): String {
        return try {
            val pkgInfo = context.packageManager.getPackageInfo(context.packageName, 0)
            val versionCode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P) {
                pkgInfo.longVersionCode
            } else {
                @Suppress("DEPRECATION")
                pkgInfo.versionCode.toLong()
            }
            "${pkgInfo.versionName}($versionCode)"
        } catch (e: Exception) {
            ""
        }
    }

    fun getOsVersion(): String {
        val sdkInt = Build.VERSION.SDK_INT
        val version = Build.VERSION.RELEASE
        Log.d("VersionCheck", "SDK_INT: $sdkInt, RELEASE: $version")
        val name = getAndroidOsName(version.toInt())
        return "$name ($version) (SDK: $sdkInt)"
    }

}