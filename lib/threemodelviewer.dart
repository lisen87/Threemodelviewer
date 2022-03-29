import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:threemodelviewer/StatusInfo.dart';

class Threemodelviewer {
  static const MethodChannel _channel = MethodChannel('ThreeModelViewerPlugin');

  static Future<String?> get platformVersion async {
    final String? version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  static enableTouch(bool enable) {
    _channel.invokeMethod('enableTouch', {"enableTouch": enable});
  }

  static final StreamController<StatusInfo> statusController = StreamController<StatusInfo>.broadcast();

  static init() {
    _channel.setMethodCallHandler((call) async {
      StatusInfo statusInfo = StatusInfo(status: call.method.toString(),info: call.arguments);
      statusController.add(statusInfo);
    });
  }
}

