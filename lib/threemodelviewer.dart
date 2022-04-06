import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:threemodelviewer/StatusInfo.dart';

class Threemodelviewer {
  late MethodChannel _channel;

  enableTouch(bool enable) {
    _channel.invokeMethod('enableTouch', {"enableTouch": enable});
  }

  late StreamController<StatusInfo> statusController;

  init() {
    statusController = StreamController<StatusInfo>.broadcast();
    _channel = const MethodChannel('ThreeModelViewerPlugin');
    _channel.setMethodCallHandler((call) async {
      StatusInfo statusInfo = StatusInfo(status: call.method.toString(),info: call.arguments);
      statusController.add(statusInfo);
    });
  }
}

