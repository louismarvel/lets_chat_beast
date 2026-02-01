import 'package:zego_zpns/src/internal/zpns_defines_extension.dart';
import 'package:zego_zpns/src/zpns_defines.dart';

class ZPNsConverter {
  static ZPNsConfig cnvZPNsConfigMapToObject(Map configMap) {
    ZPNsConfig zpnsConfig = ZPNsConfig();

    zpnsConfig.enableHWPush = configMap['hw_push'];
    zpnsConfig.enableMiPush = configMap['xiaomi_push'];
    zpnsConfig.enableVivoPush = configMap['vivo_push'];
    zpnsConfig.enableOppoPush = configMap['oppo_push'];
    zpnsConfig.enableFCMPush = configMap['fcm_push'];

    zpnsConfig.miAppID = configMap['miAppID'];
    zpnsConfig.miAppKey = configMap['miAppKEY'];

    zpnsConfig.oppoAppID = configMap['oppoAppID'];
    zpnsConfig.oppoAppSecret = configMap['oppoAppSecret'];
    zpnsConfig.oppoAppKey = configMap['oppoAppKey'];

    zpnsConfig.vivoAppID = configMap['vivoAppID'];
    zpnsConfig.vivoAppKey = configMap['vivoAppKey'];

    zpnsConfig.hwAppID = configMap['hwAppID'];

    zpnsConfig.appType = configMap['appType'];

    zpnsConfig.enableHwBadge = configMap['enableHwBadge'];

    return zpnsConfig;
  }

  static Map cnvZPNsConfigObjectToMap(ZPNsConfig config) {
    Map configMap = {};

    configMap['hw_push'] = config.enableHWPush;
    configMap['xiaomi_push'] = config.enableMiPush;
    configMap['vivo_push'] = config.enableVivoPush;
    configMap['oppo_push'] = config.enableOppoPush;
    configMap['fcm_push'] = config.enableFCMPush;

    configMap['miAppID'] = config.miAppID;
    configMap['miAppKEY'] = config.miAppKey;
    configMap['oppoAppID'] = config.oppoAppID;
    configMap['oppoAppSecret'] = config.oppoAppSecret;
    configMap['oppoAppKey'] = config.oppoAppKey;

    configMap['vivoAppID'] = config.vivoAppID;
    configMap['vivoAppKey'] = config.vivoAppKey;

    configMap['hwAppID'] = config.hwAppID;

    configMap['appType'] = config.appType;
    configMap['enableHwBadge'] = config.enableHwBadge;

    return configMap;
  }

  static ZPNsMessage cnvZPNsMessageMapToObject(Map messageMap) {
    ZPNsMessage message = ZPNsMessage(
        pushSourceType: ZPNsPushSourceTypeExtension
            .mapValue[messageMap['pushSourceType']]!);
    message.title = messageMap['title'] ?? "";
    message.content = messageMap['content'] ?? "";
    message.payload = messageMap['payload'] ?? "";
    message.extras = Map<String, Object?>.from(messageMap['extras'] ?? {});
    return message;
  }

  static ZPNsRegisterMessage cnvZPNsRegisterMessageMapToObject(Map messageMap) {
    ZPNsRegisterMessage registerMessage = ZPNsRegisterMessage(
        errorCode: messageMap["errorCode"],
        pushID: messageMap["pushID"],
        pushSourceType: ZPNsPushSourceTypeExtension
            .mapValue[messageMap['pushSourceType']]!);
    registerMessage.errorMessage = messageMap['msg'];
    registerMessage.commandResult = messageMap['commandResult'];
    return registerMessage;
  }

  static Map cnvZPNsLocalMessageObjectToMap(ZPNsLocalMessage message) {
    Map msgMap = {};
    msgMap['title'] = message.title;
    msgMap['content'] = message.content;
    msgMap['payload'] = message.payload;
    msgMap['channelID'] = message.channelID;
    msgMap['iOSSound'] = message.iOSSound;
    msgMap['androidSound'] = message.androidSound;
    return msgMap;
  }

  static Map cnvZPNsNotificationChannelToMap(ZPNsNotificationChannel channel) {
    Map channelMap = {};
    channelMap['channelID'] = channel.channelID;
    channelMap['channelName'] = channel.channelName;
    channelMap['androidSound'] = channel.androidSound;
    return channelMap;
  }

  static Map cnvZPNsWebConfigToMap(ZPNsWebConfig config) {
    Map msgMap = {};
    msgMap['apiKey'] = config.apiKey;
    msgMap['appId'] = config.appID;
    msgMap['authDomain'] = config.authDomain;
    msgMap['measurementId'] = config.measurementID;
    msgMap['messagingSenderId'] = config.messagingSenderID;
    msgMap['projectId'] = config.projectID;
    msgMap['storageBucket'] = config.storageBucket;
    msgMap['vapidKey'] = config.vapidKey;
    return msgMap;
  }
}
