package dev.eronildo.app_center

import androidx.annotation.NonNull

import android.app.Application
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import com.microsoft.appcenter.AppCenter
import com.microsoft.appcenter.analytics.Analytics
import com.microsoft.appcenter.crashes.Crashes

/** AppCenterPlugin */
class AppCenterPlugin: FlutterPlugin, MethodCallHandler {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private var application: Application? = null

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    application = flutterPluginBinding.applicationContext as Application
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "app_center")
    channel.setMethodCallHandler(this)
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    when (call.method) {
      "start" -> {
        val secret: String? = call.argument("secret")
        AppCenter.start(application, secret, Analytics::class.java, Crashes::class.java)
        result.success(true)
      }
      "trackEvent" -> {
        val name: String? = call.argument("name")
        val properties: Map<String, String>? = call.argument("properties")
        Analytics.trackEvent(name, properties)
      }
      "trackError" -> {
        val errorMessage: String? = call.argument("errorMessage")
        val trackErrorProperties: Map<String, String>? = call.argument("properties")
        val stackTrace: List<Map<String, String>>? = call.argument("stackTrace")
        val stackTraceElements = mutableListOf<StackTraceElement>()
        stackTrace?.forEach { element ->
          stackTraceElements.add(StackTraceElement(element["declaringClass"], element["methodName"], element["fileName"], element["lineNumber"]?.toInt() ?: 0))
        }
        val exception = Exception(errorMessage)
        exception.stackTrace = stackTraceElements.toTypedArray()
        Crashes.trackError(exception, trackErrorProperties, null)
      }
      else -> {
        result.notImplemented()
      }
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }
}
