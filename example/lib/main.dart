import 'dart:io';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:threemodelviewer/ThreeView.dart';
import 'package:threemodelviewer/threemodelviewer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await Threemodelviewer.platformVersion ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Row(
          children: [
            // Container(
            //   height: 300,
            //   width: 300,
            //   color: Colors.red,
            //   child: const ThreeView(
            //     src: "assets/ship.obj",
            //     modelType: ModelType.assets,
            //     srcDrawable: [
            //       "assets/ship.bmp",
            //       "assets/ship.mtl",
            //       "assets/ship.png",
            //     ],
            //   ),
            // ),
            // Container(
            //   height: 300,
            //   width: 300,
            //   color: Colors.green,
            //   child: const ThreeView(
            //     src: "文件路径path",
            //     modelType: ModelType.file,
            //   ),
            // ),
            Container(
              height: 300,
              width: 300,
              color: Colors.blue,
              child: const ThreeView(
                src: "http://xingchen.p1.sdqttx.net:91/test/ship.obj",
                modelType: ModelType.http,
                srcDrawable: [
                  "http://xingchen.p1.sdqttx.net:91/test/ship.bmp",
                  "http://xingchen.p1.sdqttx.net:91/test/ship.mtl",
                  "http://xingchen.p1.sdqttx.net:91/test/ship.png",
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}