import 'dart:async';

import 'package:flutter/services.dart';

import '../../zego_zpns.dart';
import 'zpns_manager.dart';

class ZPNsSettings{
  static const MethodChannel _channel = MethodChannel("zego_zpns");
  static const EventChannel eventChannel = EventChannel('zpns_event_handler');
  static StreamSubscription<dynamic>? streamSubscription;
  static bool _instanceInited = false;

  static MethodChannel get channel {
    if(!_instanceInited) {
      _channel.setMethodCallHandler((MethodCall call) async {
        final Map<dynamic, dynamic> map = call.arguments;
        switch (call.method) {
          case 'onThroughBackgroundMessageForIOS':
            ZPNsMessage message = ZPNsMessage(pushSourceType: ZPNsPushSourceType.APNs);
            message.extras = Map<String, Object?>.from(map);
            return ZPNsManager.backgroundMessageHandler?.call(message);
          default:
            break;
        }
      });
      _instanceInited = true;
    }
    return _channel;
  }
}