import 'package:app_center_plugin/app_center_plugin.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stack_trace/stack_trace.dart';

void main() {
  const MethodChannel channel = MethodChannel('app_center');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'trackEvent':
        case 'trackError':
          break;
        default:
          return true;
      }
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (_) => null);
  });

  test('AppCenter.start', () async {
    expect(await AppCenter.start('any_secret'), true);
  });

  test('AppCenter.trackError', () {
    expect(AppCenter.trackError('error_message'), completes);
  });

  test('AppCenter.trackEvent', () {
    expect(AppCenter.trackEvent('any_event'), completes);
  });

  group('Given stack trace ', () {
    test('Should convert when stack trace is mocked', () {
      final linesOfStackTrace =
          convertStackTrace(Trace.parse(stackTrace).original);

      expect(linesOfStackTrace![0]["declaringClass"], "_MyHomePageState");
      expect(linesOfStackTrace[0]["methodName"], "_trackError");
      expect(linesOfStackTrace[0]["fileName"], "main.dart");
      expect(linesOfStackTrace[0]["lineNumber"], "110");
    });

    test('Should convert when exception is throw', () {
      try {
        throw Exception();
      } catch (e, s) {
        final linesOfStackTrace = convertStackTrace(s);

        expect(linesOfStackTrace![0]["declaringClass"], "main");
        expect(linesOfStackTrace[0]["methodName"], "<fn>.<fn>");
        expect(linesOfStackTrace[0]["fileName"], "app_center_plugin_test.dart");
        expect(linesOfStackTrace[0]["lineNumber"], "55");
      }
    });

    test('Should convert when stack trace is null', () {
      final linesOfStackTrace = convertStackTrace(null);

      expect(linesOfStackTrace, isNull);
    });
  });
}

const stackTrace = """
#0      _MyHomePageState._trackError (package:app_center_example/main.dart:110:5)
#1      _InkResponseState._handleTap (package:flutter/src/material/ink_well.dart:989:21)
#2      GestureRecognizer.invokeCallback (package:flutter/src/gestures/recognizer.dart:198:24)
#3      TapGestureRecognizer.handleTapUp (package:flutter/src/gestures/tap.dart:608:11)
#4      BaseTapGestureRecognizer._checkUp (package:flutter/src/gestures/tap.dart:296:5)
#5      BaseTapGestureRecognizer.acceptGesture (package:flutter/src/gestures/tap.dart:267:7)
#6      GestureArenaManager.sweep (package:flutter/src/gestures/arena.dart:157:27)
#7      GestureBinding.handleEvent (package:flutter/src/gestures/binding.dart:443:20)
#8      GestureBinding.dispatchEvent (package:flutter/src/gestures/binding.dart:419:22)
#9      RendererBinding.dispatchEvent (package:flutter/src/rendering/binding.dart:322:11)
#10     GestureBinding._handlePointerEventImmediately (package:flutter/src/gestures/binding.dart:374:7)
#11     GestureBinding.handlePointerEvent (package:flutter/src/gestures/binding.dart:338:5)
#12     GestureBinding._flushPointerEventQueue (package:flutter/src/gestures/binding.dart:296:7)
#13     GestureBinding._handlePointerDataPacket (package:flutter/src/gestures/binding.dart:279:7)
#14     _rootRunUnary (dart:async/zone.dart:1444:13)
#15     _CustomZone.runUnary (dart:async/zone.dart:1335:19)
#16     _CustomZone.runUnaryGuarded (dart:async/zone.dart:1244:7)
#17     _invoke1 (dart:ui/hooks.dart:169:10)
#18     PlatformDispatcher._dispatchPointerDataPacket (dart:ui/platform_dispatcher.dart:293:7)
#19     _dispatchPointerDataPacket (dart:ui/hooks.dart:88:31)

""";
