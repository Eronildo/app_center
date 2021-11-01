import 'dart:async';

import 'package:flutter/services.dart';

class AppCenter {
  static const MethodChannel _channel = MethodChannel('app_center');

  static Future<dynamic> start(String secret) {
    return _channel
        .invokeMethod('start', <String, dynamic>{'secret': secret});
  }

  static Future trackEvent(String name, [Map<String, String>? properties]) =>
      _channel.invokeMethod('trackEvent', <String, dynamic>{
        'name': name,
        'properties': properties ?? <String, String>{},
      });

  static Future trackError(String errorMessage,
          [Map<String, String>? properties]) =>
      _channel.invokeMethod('trackError', <String, dynamic>{
        'errorMessage': errorMessage,
        'properties': properties ?? <String, String>{},
      });
}
