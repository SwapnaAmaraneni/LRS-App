import UIKit
import Flutter
import GoogleMaps
@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      // TODO: Add your Google Maps API key
          GMSServices.provideAPIKey("AIzaSyDqnvHAT_rFPF2v3JjAlB9hBfvvTwCoKpg")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
