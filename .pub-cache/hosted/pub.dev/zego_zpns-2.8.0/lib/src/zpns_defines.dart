///Description: ZPNs push configuration class.
///
///Use cases: Add the required configuration items pushed by each vendor and a Boolean value for whether to enable them.
class ZPNsConfig {
  bool enableHWPush = false;

  bool enableMiPush = false;

  bool enableVivoPush = false;

  bool enableOppoPush = false;

  bool enableFCMPush = false;

  bool enableHwBadge = false;

  String miAppID = "";

  String miAppKey = "";

  String oppoAppID = "";

  String oppoAppSecret = "";

  String oppoAppKey = "";

  String vivoAppID = "";

  String vivoAppKey = "";

  String hwAppID = "";

  int appType = 0;
}

///Description: ZPNs message class.
///
///Use cases: Use the object of this data class to get the details of the push message.
class ZPNsMessage {
  String title = "";
  String content = "";
  String payload = "";
  Map<String, Object?> extras = {};
  ZPNsPushSourceType pushSourceType;
  ZPNsMessage({required this.pushSourceType});
}

class ZPNsLocalMessage {
  String title = "";
  String content = "";
  //IOS only
  String payload = "";
  String iOSSound = "";
  String androidSound = "";
  String channelID = "";
}

class ZPNsNotificationChannel {
  String channelID = "";
  String channelName = "";
  String androidSound = "";
}

class ZPNsRegisterMessage {
  String pushID;

  int errorCode;

  ZPNsPushSourceType pushSourceType;

  String errorMessage = "";

  String commandResult = "";

  ZPNsRegisterMessage(
      {required this.errorCode,
      required this.pushID,
      required this.pushSourceType});
}

class ZPNsWebConfig {
  String apiKey = "";
  String authDomain = "";
  String projectID = "";
  String storageBucket = "";
  String messagingSenderID = "";
  String appID = "";
  String measurementID = "";
  String vapidKey = "";
}

enum ZPNsIOSEnvironment { Production, Development, Automatic }

enum ZPNsIOSBackgroundFetchResult {
  /// New data was successfully downloaded.
  NewData,

  /// There was no new data to download.
  NoData,

  /// An attempt to download data was made but that attempt failed.
  Failed
}

class ZPNsIOSNotificationArrivedConfig {
  bool isPresentBadge = false;
  bool isPresentSound = false;
  bool isPresentAlert = false;
}

enum ZPNsPushSourceType { APNs, ZEGO, FCM, HuaWei, XiaoMi, Oppo, Vivo }

void Function(ZPNsIOSBackgroundFetchResult result)?
    iOSOnThroughMessageReceivedCompletion;

typedef ZPNsBackgroundMessageHandler = Future<void> Function(
    ZPNsMessage message);
