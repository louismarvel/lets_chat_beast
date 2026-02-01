import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:zego_zpns/src/internal/zpns_converter.dart';
import 'package:zego_zpns/src/internal/zpns_event_handler_impl.dart';
import 'package:zego_zpns/src/internal/zpns_settings.dart';
import 'package:zego_zpns/zego_zpns.dart';
import 'package:universal_io/io.dart';

class ZPNsEngine implements ZPNs {
  ZPNsEngine() {
    ZPNsEventHandlerImpl.registerEventHandler();

  }

  @override
  Future<void> registerPush({ZPNsIOSEnvironment? iOSEnvironment, ZPNsIOSNotificationArrivedConfig? iOSNotificationArrivedConfig, bool? enableIOSVoIP, ZPNsWebConfig? webConfig}) async {
    if (kIsWeb) {
      if (webConfig == null) {
        throw PlatformException(
          code: 'ParamError',
          details: 'zpns for web param config no found',
        );
      }

      return ZPNsSettings.channel.invokeMethod('registerPush', {
        'webConfig': ZPNsConverter.cnvZPNsWebConfigToMap(webConfig),
        // 'zim': zim
      });
    }
    Map extendedData = {};
    if (Platform.isIOS || Platform.isMacOS) {
      iOSEnvironment ??= ZPNsIOSEnvironment.Automatic;
      switch (iOSEnvironment) {
        case ZPNsIOSEnvironment.Development:
          ZPNsSettings.channel.invokeMethod('enableDebug', {'debug': true});
          break;
        case ZPNsIOSEnvironment.Production:
          ZPNsSettings.channel.invokeMethod('enableDebug', {'debug': false});
          break;
        case ZPNsIOSEnvironment.Automatic:
          await ZPNsSettings.channel.invokeMethod('automaticDetection');
          break;
      }

      extendedData["enableIosVoIP"] = enableIOSVoIP;

      if(iOSNotificationArrivedConfig != null) {
        extendedData["iOSPresentBadge"] = iOSNotificationArrivedConfig.isPresentBadge;
        extendedData["iOSPresentSound"] = iOSNotificationArrivedConfig.isPresentSound;
        extendedData["iOSPresentAlert"] = iOSNotificationArrivedConfig.isPresentAlert;
      }
    }
    return await ZPNsSettings.channel.invokeMethod('registerPush',{'extendedData':extendedData});
  }

  @override
  Future<void> unregisterPush() async {
    return await ZPNsSettings.channel.invokeMethod('unregisterPush');
  }

  @override
  Future<void> applyNotificationPermission() async {
    return await ZPNsSettings.channel.invokeMethod('applyNotificationPermission');
  }

  @override
  Future<void> addLocalNotification(ZPNsLocalMessage message) async {
    return await ZPNsSettings.channel.invokeMethod('addLocalNotification',
        {'message': ZPNsConverter.cnvZPNsLocalMessageObjectToMap(message)});
  }

  @override
  Future<void> createNotificationChannel(
      ZPNsNotificationChannel channel) async {
    return await ZPNsSettings.channel.invokeMethod('createNotificationChannel',
        {'channel': ZPNsConverter.cnvZPNsNotificationChannelToMap(channel)});
  }



  registerBackgroundMessageHandler(ZPNsBackgroundMessageHandler handler) async{
      if(!Platform.isAndroid){
        return;
      }
      final CallbackHandle backgroundHandle = PluginUtilities.getCallbackHandle(_zpnsMessagingCallbackDispatcher)!;
      final CallbackHandle userHandle = PluginUtilities.getCallbackHandle(handler)!;
      await ZPNsSettings.channel.invokeMethod('storeBackgroundHandle',{'pluginCallbackHandle':backgroundHandle.toRawHandle(),'userCallbackHandle':userHandle.toRawHandle()});
  }

  @override
  Future<void> setLocalBadge(int badge) {
    return ZPNsSettings.channel.invokeMethod('setLocalBadge',{'badge':badge});
  }

  @override
  Future<void> setServerBadge(int badge) {
    if(!Platform.isIOS){
      return Future(() => null);
    }
    return ZPNsSettings.channel.invokeMethod('setServerBadge',{'badge':badge});
  }

}

// Only for Android background message
@pragma('vm:entry-point')
void _zpnsMessagingCallbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();

  const MethodChannel _channel = MethodChannel(
    'zego_zpns_background',
  );

  _channel.setMethodCallHandler((MethodCall call) async {
    print('Flutter Call background message');
    print(call.method);
    if (call.method == 'onThroughBackgroundMessage') {

      print("Flutter callback userCallbackHandle start");
      print(call.arguments);
      final CallbackHandle handle =
      CallbackHandle.fromRawHandle(call.arguments['userCallbackHandle']);
      print("Flutter callback userCallbackHandle");
      // PluginUtilities.getCallbackFromHandle performs a lookup based on the
      // callback handle and returns a tear-off of the original callback.
      final closure = PluginUtilities.getCallbackFromHandle(handle)!
      as Future<void> Function(ZPNsMessage message);

      try {
        ZPNsMessage zpNsMessage = ZPNsConverter.cnvZPNsMessageMapToObject((call.arguments['message'])['message']);
        await closure(zpNsMessage);
      } catch (e) {
        // ignore: avoid_print
        print(
            'FlutterFire Messaging: An error occurred in your background messaging handler:');
        // ignore: avoid_print
        print(e);
      }
    } else {
      throw UnimplementedError('${call.method} has not been implemented');
    }
  });

  _channel.invokeMethod<void>('initializedBackgroundExecutor');
}
