import 'package:flutter/services.dart';

class AppInfo {
  static const _channel = MethodChannel('com.zynth.trackher/info');

  static Future<DateTime?> getInstallDate() async {
    try {
      final timestamp = await _channel.invokeMethod<int>('getInstallDate');
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp);
      }
    } on PlatformException {
      return null;
    }
    return null;
  }

  static Future<String?> getAppVersion() async {
    try {
      final version = await _channel.invokeMethod<String>('getAppVersion');
      if (version != null) {
        return version;
      }
    } on PlatformException {
      return null;
    }
    return null;
  }

  static Future<int?> getBatteryLevel() async {
    try {
      final batteryLevel = await _channel.invokeMethod<int>('getBatteryLevel');
      if (batteryLevel != null) {
        return batteryLevel;
      }
    } on PlatformException {
      return null;
    }
    return null;
  }

  static Future<String?> getOsVersion() async {
    try {
      final osVersion = await _channel.invokeMethod<String>('getOsVersion');
      if (osVersion != null) {
        return osVersion;
      }
    } on PlatformException {
      return null;
    }
    return null;
  }
}
