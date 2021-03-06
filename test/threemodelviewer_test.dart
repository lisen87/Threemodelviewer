import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:threemodelviewer/threemodelviewer.dart';

void main() {
  const MethodChannel channel = MethodChannel('threemodelviewer');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

}
