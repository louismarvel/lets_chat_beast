
import 'dart:async';
import 'dart:html';
import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:zego_zpns/src/zim_defines_web.dart';
import 'package:zego_zpns/src/zpns_defines_web.dart';
import 'dart:js_util' as js;

class ZegoZpnsPlugin {
  ZegoZpnsPlugin();

  static final StreamController _evenController = StreamController.broadcast();

  static void registerWith(Registrar registrar) {
    //ZimFlutterSdkPlatform.instance = ZimFlutterSdkWeb();
    final MethodChannel channel = MethodChannel(
      'zego_zpns',
      const StandardMethodCodec(),
      registrar,
    );

    final eventChannel = PluginEventChannel(
        'zpns_event_handler', const StandardMethodCodec(), registrar);

    final pluginInstance = ZegoZpnsPlugin();
    channel.setMethodCallHandler(pluginInstance.handleMethodCall);
    eventChannel.setController(ZegoZpnsPlugin._evenController);

    _evenController.stream.listen((event) {
      _eventListener(event);
    });
  }

  Future<dynamic> handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'getVersion':
        return getVersion();
      case 'registerPush':
        return registerPush (call.arguments["webConfig"]);
      case 'unregisterPush':
        return unregisterPush();
      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: 'zpns for web doesn\'t implement \'${call.method}\'',
        );
    }
  }

  static void _eventListener(dynamic event) {}

  static String getVersion() {
    return ZPNs.getVersion();
  }

  static void registerPush(dynamic config) {
    Object _config = mapToJSObj(config);
    ZPNs.getInstance()!.register(_config, ZIM.getInstance());
  }

  static void unregisterPush() {
    ZPNs.getInstance()!.unregister();
  }

  static Object mapToJSObj(Map<dynamic, dynamic>? a) {
    var object = js.newObject();

    if (a == null) {
      return object;
    }

    a.forEach((k, v) {
      var key = k;
      var value = v;
      js.setProperty(object, key, value);
    });
    return object;
  }

}