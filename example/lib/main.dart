import 'dart:io';

import 'package:dio/dio.dart';
import 'package:example/secrets.dart';
import 'package:flutter/material.dart';
import 'package:newrelic_mobile/config.dart';
import 'package:newrelic_mobile/loglevel.dart';
import 'package:newrelic_mobile/newrelic_mobile.dart';

const mockUserId = '8f9e2ec6-0a49-4e5e-9039-027e50ced24d';
const kBaseUrl = 'http://192.168.1.56:8080';

final dio = Dio();

void main() {
  var appToken = "";

  if (Platform.isAndroid) {
    appToken = kNewrelicAppTokenAndroid;
  } else if (Platform.isIOS) {
    appToken = kNewrelicAppTokenIOS;
  }

  final config = Config(
    accessToken: appToken,
    analyticsEventEnabled: true,
    networkErrorRequestEnabled: true,
    networkRequestEnabled: true,
    crashReportingEnabled: true,
    interactionTracingEnabled: true,
    httpResponseBodyCaptureEnabled: true,
    loggingEnabled: true,
    webViewInstrumentation: true,
    printStatementAsEventsEnabled: false,
    httpInstrumentationEnabled: true,
    distributedTracingEnabled: true,
    logLevel: LogLevel.VERBOSE,
    newEventSystemEnabled: true,
  );

  NewrelicMobile.instance.start(config, () {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Demo App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

Future<void> _customEvent() async {
  NewrelicMobile.instance.recordCustomEvent(
    "Mobile Custom Event",
    eventName: "user_pressed_test_event",
    eventAttributes: {
      "product_id": "87cad3c8-7569-4fb6-a972-7a5fee177e96",
      "amount": 2.0,
      "price": 7.5,
    },
  );
}

Future<void> _handledException() async {
  try {
    throw UnimplementedError('Test handled exception');
  } catch (e, stackTrace) {
    NewrelicMobile.instance.recordError(e, stackTrace);
  }
}

Future<void> _http200Request() async {
  await dio.get('$kBaseUrl/test-rest-success');
}

Future<void> _http404Request() async {
  await dio.get('$kBaseUrl/test-rest-missing');
}

Future<void> _http500Request() async {
  await dio.get('$kBaseUrl/test-rest-server-error');
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();

    NewrelicMobile.instance.setUserId(mockUserId);
  }

  @override
  Widget build(BuildContext context) {
    const interButtonSpace = 20.0;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: interButtonSpace,
          children: <Widget>[
            Text('UserId: $mockUserId'),
            ElevatedButton(
              onPressed: _customEvent,
              child: Text('Custom Event'),
            ),
            ElevatedButton(
              onPressed: _handledException,
              child: Text('Handled Exception'),
            ),
            ElevatedButton(
              onPressed: _http200Request,
              child: Text('Http Request 200'),
            ),
            ElevatedButton(
              onPressed: _http404Request,
              child: Text('Http Request 404'),
            ),
            ElevatedButton(
              onPressed: _http500Request,
              child: Text('Http Request 500'),
            ),
          ],
        ),
      ),
    );
  }
}
