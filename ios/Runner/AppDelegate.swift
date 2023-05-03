import UIKit
import Flutter
import GoogleMaps
import flutter_background_service_ios

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    self.window.secureApp()
    GMSServices.provideAPIKey("AIzaSyDwfxo5NPOPD_JED1tiZfoHbIUBgcHX8j4")
    SwiftFlutterBackgroundServicePlugin.taskIdentifier = "your.custom.task.identifier"
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

extension UIWindow {
func secureApp() {
    let field = UITextField()
    field.isSecureTextEntry = true
    self.addSubview(field)
    field.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    field.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
    self.layer.superlayer?.addSublayer(field.layer)
    field.layer.sublayers?.first?.addSublayer(self.layer)
  }
}
