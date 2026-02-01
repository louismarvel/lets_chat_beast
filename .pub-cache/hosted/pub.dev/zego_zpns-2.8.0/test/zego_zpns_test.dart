import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zego_zpns/zego_zpns.dart';

void main() {
  const MethodChannel channel = MethodChannel('zego_zpns');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  // test('getPlatformVersion', () async {
  //   expect(await ZegoZpns.platformVersion, '42');
  // });
}
