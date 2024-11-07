import UIKit
import Flutter
import Firebase
import GoogleMaps // Add this import statement

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()

    // Provide your Google Maps API key
    GMSServices.provideAPIKey("AIzaSyCBzH-qu-D8DW3pKKqwdhgbMHH6PURi4KM")

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
