import 'dart:io';

import 'package:zego_zpns/src/internal/zpns_converter.dart';
import 'package:zego_zpns/src/internal/zpns_engine.dart';
import 'zpns_settings.dart';
import '../../zego_zpns.dart';

class ZPNsManager {
  static ZPNsEngine? instanceEngine;

  static ZPNsBackgroundMessageHandler? _BackGroundMessageHandler;

  static ZPNsEngine getInstance() {
    instanceEngine ??= ZPNsEngine();
    return instanceEngine!;
  }

  static Future<String> getVersion() async {
    return await ZPNsSettings.channel.invokeMethod("getVersion");
  }

  static enableDebug(bool debug) {
    if (Platform.isAndroid) {
      ZPNsSettings.channel.invokeMethod('enableDebug', {'debug': debug});
    }
  }

  static setPushConfig(ZPNsConfig config) async {
    ZPNsSettings.channel.invokeMethod('setPushConfig',
        {'config': ZPNsConverter.cnvZPNsConfigObjectToMap(config)});
  }

  static onBackgroundMessage(ZPNsBackgroundMessageHandler handler) {
    _BackGroundMessageHandler = handler;
    // Only Android need register background handler to native
    getInstance().registerBackgroundMessageHandler(handler);
  }

  static ZPNsBackgroundMessageHandler? get backgroundMessageHandler {
    return _BackGroundMessageHandler;
  }
}
