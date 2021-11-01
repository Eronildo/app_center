import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:app_center_plugin/app_center_plugin.dart';


void main() {
  const MethodChannel channel = MethodChannel('app_center');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      switch (methodCall.method) {
        case 'trackEvent':
        case 'trackError':
          break;
        default:
          return true;
      }
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
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
}
