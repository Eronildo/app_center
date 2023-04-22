import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:app_center_plugin/app_center_plugin.dart';

const androidSecret = '043be909-44a3-4675-b8b3-3078cb55d379';
const iOSSecret = '894914f3-91d8-48c0-a929-d02e8b5b2178';

void main() async {
  final secret = Platform.isAndroid ? androidSecret : iOSSecret;

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
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppCenter.trackEvent('MyApp');
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
      debugPrint("Sending event to AppCenter");
      AppCenter.trackEvent('Increment Counter', {'counter': _counter.toString()});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            onPressed: _trackError,
            tooltip: 'Error',
            child: const Icon(Icons.bug_report),
          ),
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  void _trackError() {
    debugPrint("Sending error to AppCenter");
    throw const CustomException("Custom error message");
  }
}

class CustomException implements Exception {
  const CustomException(String message);
}
