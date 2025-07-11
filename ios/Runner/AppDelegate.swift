import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  private let CHANNEL = "com.zynth.trackher/info"

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)

    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: CHANNEL, binaryMessenger: controller.binaryMessenger)

    channel.setMethodCallHandler { (call, result) in
      if call.method == "getInstallDate" {
        if let docDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last,
           let attributes = try? FileManager.default.attributesOfItem(atPath: docDir.path),
           let creationDate = attributes[.creationDate] as? Date {
          result(Int(creationDate.timeIntervalSince1970 * 1000)) // milliseconds
        } else {
          result(FlutterError(code: "UNAVAILABLE", message: "Install date not available", details: nil))
        }
      } else {
        result(FlutterMethodNotImplemented)
      }
    }

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
