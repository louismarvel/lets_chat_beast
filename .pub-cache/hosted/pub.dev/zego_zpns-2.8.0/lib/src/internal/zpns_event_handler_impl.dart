
import 'dart:io';
import 'package:zego_zpns/src/internal/zpns_converter.dart';
import 'package:zego_zpns/src/internal/zpns_settings.dart';
import 'package:zego_zpns/zego_zpns.dart';

class ZPNsEventHandlerImpl implements ZPNsEventHandler {

  static void registerEventHandler() async {
    ZPNsSettings.streamSubscription ??=
        ZPNsSettings.eventChannel.receiveBroadcastStream().listen(eventListener);

  }

  static void unregisterEventHandler() async {
    await ZPNsSettings.streamSubscription?.cancel();
    ZPNsSettings.streamSubscription = null;
  }

  static void eventListener(dynamic data) {
    final Map<dynamic, dynamic> map = data;
    switch (map['method']) {
      case 'onRegistered':
        if (ZPNsEventHandler.onRegistered == null) return;
        ZPNsRegisterMessage registerMessage =
            ZPNsConverter.cnvZPNsRegisterMessageMapToObject(map['message']);
        ZPNsEventHandler.onRegistered!(registerMessage);
        break;
      case 'onNotificationArrived':
        if (ZPNsEventHandler.onNotificationArrived == null) return;
        ZPNsMessage message =
            ZPNsConverter.cnvZPNsMessageMapToObject(map['message']);
        ZPNsEventHandler.onNotificationArrived!(message);
        break;
      case 'onNotificationClicked':
        if (ZPNsEventHandler.onNotificationClicked == null) return;

        ZPNsMessage message =
            ZPNsConverter.cnvZPNsMessageMapToObject(map['message']);

        ZPNsEventHandler.onNotificationClicked!(message);
        break;
      case 'onThroughMessageReceived':
      if (ZPNsEventHandler.onThroughMessageReceived == null) return;
        if(Platform.isIOS){
            ZPNsMessage message = ZPNsMessage(pushSourceType: ZPNsPushSourceType.APNs);
            message.extras = Map<String, Object?>.from(map['userInfo']);
            //String seq = map['seq'];
            ZPNsEventHandler.onThroughMessageReceived!(message);
        }else if(Platform.isAndroid){
          ZPNsMessage message = ZPNsConverter.cnvZPNsMessageMapToObject(map['message']);
          ZPNsEventHandler.onThroughMessageReceived!(message);
        }
        break;
      default:
    }

  }


}
