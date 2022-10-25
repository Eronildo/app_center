import 'dart:async';

import 'package:flutter/services.dart';

class AppCenter {
  static const MethodChannel _channel = MethodChannel('app_center');

  static Future<dynamic> start(String secret) {
    return _channel.invokeMethod('start', <String, dynamic>{'secret': secret});
  }

  static Future trackEvent(String name, [Map<String, String>? properties]) =>
      _channel.invokeMethod('trackEvent', <String, dynamic>{
        'name': name,
        'properties': properties ?? <String, String>{},
      });

  static Future trackError(String errorMessage,
          {Map<String, String>? properties, StackTrace? stackTrace}) =>
      _channel.invokeMethod('trackError', <String, dynamic>{
        'errorMessage': errorMessage,
        'properties': properties ?? <String, String>{},
        'stackTrace': convertStackTrace(stackTrace?.toString())
      });
}

List<Map<String, String>>? convertStackTrace(String? stackTrace) {
  if (stackTrace == null) return null;

  var list = <Map<String, String>>[];
  var lines = stackTrace.toString().split('\n');
  for (var lineRaw in lines) {
    lineRaw = lineRaw.replaceAll(RegExp(' +'), ' ');
    if (lineRaw.isEmpty) {
      continue;
    }

    var line = lineRaw.split(' ');
    var classAndMethod = line[1].split('.');
    String declaringClass;
    String methodName;
    if (classAndMethod.length > 1) {
      declaringClass = classAndMethod[0];
      methodName = classAndMethod[1];
    } else {
      declaringClass = "";
      methodName = classAndMethod[0];
    }

    var fileAndLineRaw = line[2];
    fileAndLineRaw = fileAndLineRaw.replaceAll('(', '');
    fileAndLineRaw = fileAndLineRaw.replaceAll(')', '');
    var fileAndLine = fileAndLineRaw.split(':');
    String fileName;
    String lineNumber;
    if (fileAndLineRaw.length > 3) {
      fileName = "${fileAndLine[0]}:${fileAndLine[1]}";
      lineNumber = fileAndLine[2];
    } else {
      fileName = fileAndLine[0];
      lineNumber = fileAndLine[1];
    }
    list.add({
      "declaringClass": declaringClass,
      "methodName": methodName,
      "fileName": fileName,
      "lineNumber": lineNumber
    });
  }
  return list;
}
