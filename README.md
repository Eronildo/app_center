# AppCenter Plugin

## Android Prerequisites

* You're targeting devices running Android Version 5.0 (API level 21) or later.

For more details: [Get Started with Android](https://docs.microsoft.com/en-us/appcenter/sdk/getting-started/android).

## iOS Prerequisites

* You're targeting devices running on iOS 9.0 or later.

* Run `pod install` inside `ios folder` in your project to install AppCenter dependencies.

> [!NOTE]
> If you see an error like ```[!] Unable to find a specification for `AppCenter` ``` while running `pod install`, run `pod repo update` to get the latest pods from the Cocoapods repository and then run `pod install`

For more details: [Get Started with iOS](https://docs.microsoft.com/en-us/appcenter/sdk/getting-started/ios).

## Usage

Simple package usage:

```dart
import 'package:app_center_plugin/app_center_plugin.dart';

final secret = Platform.isAndroid ? 'ANDROID_SECRET' : 'IOS_SECRET';

await AppCenter.start(secret);
  
AppCenter.trackEvent('my event', <String, String> {
  'prop1': 'prop1',
  'prop2': 'prop2',
});

AppCenter.trackError('error message');
```

How to catch Flutter and Dart errors:

```dart
WidgetsFlutterBinding.ensureInitialized();

// Start AppCenter
await AppCenter.start(secret);

// Log Flutter errors with FlutterError.onError
FlutterError.onError = (FlutterErrorDetails errorDetails) {
  FlutterError.presentError(errorDetails);
  // Send Flutter errors to AppCenter
  AppCenter.trackError(
    errorDetails.exceptionAsString(),
    properties: {"library": errorDetails.library ?? ""},
    stackTrace: errorDetails.stack,
  );
};

// Log errors not caught by Flutter with PlatformDispatcher.instance.onError
PlatformDispatcher.instance.onError = (error, stack) {
  AppCenter.trackError(
    error.toString(),
    stackTrace: stack,
  );
  return true;
};

runApp(const MyApp());
```

Check out the [official documentation](https://docs.flutter.dev/testing/errors) for more information on how to handle errors in Flutter 
