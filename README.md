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

```dart
import 'package:app_center/app_center.dart';

final secret = Platform.isAndroid ? 'ANDROID_SECRET' : 'IOS_SECRET';

await AppCenter.start(secret);
  
AppCenter.trackEvent('my event', <String, String> {
  'prop1': 'prop1',
  'prop2': 'prop2',
});

AppCenter.trackError('error message');
```