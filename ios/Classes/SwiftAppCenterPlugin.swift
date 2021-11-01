import Flutter
import UIKit
import AppCenter
import AppCenterAnalytics
import AppCenterCrashes

public class SwiftAppCenterPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "app_center", binaryMessenger: registrar.messenger())
    let instance = SwiftAppCenterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch (call.method) {
        case "start":
          guard let args:[String: Any] = (call.arguments as? [String: Any]) else {
              result(FlutterError(code: "400", message:  "Bad arguments", details: "iOS could not recognize flutter arguments in method: (start)") )
              return
          }
          let secret = args["secret"] as! String
          AppCenter.start(withAppSecret: secret, services: [
            Analytics.self,
            Crashes.self,
          ])
          result(true)
        case "trackEvent":
          self.trackEvent(call: call, result: result)
          return
        case "trackError":
          self.trackError(call: call, result: result)
          return
        default: result(FlutterMethodNotImplemented)
    }
  }

  private func trackEvent(call: FlutterMethodCall, result: FlutterResult) {
      guard let args:[String: Any] = (call.arguments as? [String: Any]) else {
          result(FlutterError(code: "400", message:  "Bad arguments", details: "iOS could not recognize flutter arguments in method: (trackEvent)") )
          return
      }

      let name = args["name"] as? String
      let properties = args["properties"] as? [String: String]
      if(name != nil) {
          Analytics.trackEvent(name!, withProperties: properties)
      }
  }

  private func trackError(call: FlutterMethodCall, result: FlutterResult) {
      guard let args:[String: Any] = (call.arguments as? [String: Any]) else {
          result(FlutterError(code: "400", message:  "Bad arguments", details: "iOS could not recognize flutter arguments in method: (trackError)") )
          return
      }

      let errorMessage = args["errorMessage"] as? String
      let properties = args["properties"] as? [String: String]
      if(errorMessage != nil) {
          Crashes.trackError(
              NSError(domain: errorMessage!, code: 1),
              properties: properties,
              attachments: nil)
      }
  }
}
