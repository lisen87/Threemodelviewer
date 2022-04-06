import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:threemodelviewer/StatusInfo.dart';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
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
              height: 500,
              width: 500,
              color: Colors.blue,
              child:  ThreeView(
                src: "assets/ship.obj",
                modelType: ModelType.assets,
                enableTouch: true,
                srcDrawable: const [
                  "assets/ship.mtl",
                  "assets/ship.bmp",
                  "assets/ship.png",
                ],
                loadCallback: (statusInfo){
                  print("loadCallback == "+ statusInfo.status.toString());
                },
              ),
            ),
            ElevatedButton(
              child: const Text("禁用手势"),
              onPressed: () {
                Threemodelviewer().enableTouch(false);
              },
            ),
            ElevatedButton(
              child: const Text("开启手势"),
              onPressed: () {
                Threemodelviewer().enableTouch(true);
              },
            ),
          ],
        ),
      ),
    );
  }

}
