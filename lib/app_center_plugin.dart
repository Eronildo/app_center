import 'dart:async';

import 'package:flutter/services.dart';
import 'package:stack_trace/stack_trace.dart';

/// App Center Plugin
class AppCenter {
  static const MethodChannel _channel = MethodChannel('app_center');

  /// Start App Center Modules
  ///
  /// Requires an App Center [secret].
  static Future<dynamic> start(String secret) {
    return _channel.invokeMethod('start', <String, dynamic>{'secret': secret});
  }

  /// Analytics - Track Custom Events
  ///
  /// Requires an Event [name]
  /// The [properties] are optinals.
  static Future trackEvent(String name, [Map<String, String>? properties]) =>
      _channel.invokeMethod('trackEvent', <String, dynamic>{
        'name': name,
        'properties': properties ?? <String, String>{},
      });

  /// Crashes - Track Errors
  ///
  /// Requires an [errorMessage]
  /// The [properties] and [stackTrace] are optinals.
  static Future trackError(String errorMessage,
          {Map<String, String>? properties, StackTrace? stackTrace}) =>
      _channel.invokeMethod('trackError', <String, dynamic>{
        'errorMessage': errorMessage,
        'properties': properties ?? <String, String>{},
        'stackTrace': convertStackTrace(stackTrace)
      });
}

/// Convert a [StackTrace] in a List of Maps.
List<Map<String, String>>? convertStackTrace(StackTrace? stackTrace) {
  if (stackTrace == null) return null;

  var trace = Trace.from(stackTrace);

  var result = <Map<String, String>>[];

  for (var frame in trace.frames) {
    String? member = frame.member;
    String declaringClass = '';
    String methodName = '';

    if (member != null) {
      var splittedMember = member.split('.');
      declaringClass =
          splittedMember.length > 1 ? splittedMember.removeAt(0) : '';
      methodName = splittedMember.join('.');
    }

    var fileName = frame.uri.path.split('/').last;

    result.add({
      'declaringClass': declaringClass,
      'methodName': methodName,
      'fileName': fileName,
      'lineNumber': frame.line?.toString() ?? ''
    });
  }
  return result;
}
