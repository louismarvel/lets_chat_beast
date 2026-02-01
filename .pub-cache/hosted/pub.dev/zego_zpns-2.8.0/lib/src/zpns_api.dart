import 'package:zego_zpns/src/internal/zpns_manager.dart';
import 'package:zego_zpns/zego_zpns.dart';

abstract class ZPNs {
//Common

  /// Available since: 2.1.0 or later.
  ///
  ///Description: Get the ZPNs instance.
  ///
  ///Use cases: This method is used to obtain ZPNs singletons when ZPNs is used.
  static ZPNs getInstance() {
    return ZPNsManager.getInstance();
  }

  /// Available since: 2.1.0.
  ///
  /// Description: Get the SDK version.
  ///
  /// Use cases:
  /// 1. When the SDK is running, the developer finds that it does not match the expected situation and submits the problem and related logs to the ZEGO technical staff for locating. The ZEGO technical staff may need the information of the engine version to assist in locating the problem.
  /// 2. Developers can also collect this information as the version information of the engine used by the app, so that the SDK corresponding to each version of the app on the line.
  ///
  /// When to call : It can be called at any time.
  static Future<String> getVersion() async {
    return await ZPNsManager.getVersion();
  }

  /// Android only
  ///Available since: 2.1.0 or later.
  ///
  ///Description: This method is used to notify the SDK of the current operating environment, default is false.
  ///
  /// Use cases: This interface is called and set to true when the developer needs to use ZPNs in the debug environment.
  ///
  /// [debug] debug is a bool ,if the current environment is debug,pass true.
  static enableDebug(bool debug) {
    ZPNsManager.enableDebug(debug);
  }

  /// Android only
  ///Available since: 2.1.0 or later.
  ///
  ///Description: Set push Settings for each vendor.
  ///
  ///Use cases: Developers need to use this method to set up configurations pushed by vendors.
  ///
  ///Default value: Called when vendor push needs to be set.
  ///[conifg] Add the required configuration items pushed by each vendor and a Boolean value for whether to enable them.
  static setPushConfig(ZPNsConfig config) {
    return ZPNsManager.setPushConfig(config);
  }

  static setBackgroundMessageHandler(ZPNsBackgroundMessageHandler handler) {
    return ZPNsManager.onBackgroundMessage(handler);
  }
  /// iOS only
  ///Available since: 2.2.0 or later.
  ///
  /// Description: Send a local notification.
  Future<void> addLocalNotification(ZPNsLocalMessage message);


  /// Android only
  ///
  ///Available since: 2.2.0 or later.
  Future<void> createNotificationChannel(ZPNsNotificationChannel channel);

  /// iOS only
  ///Available since: 2.1.0 or later.
  ///
  ///Description: This method is used to register vendor offline push.
  ///
  /// Use cases: This method is called before needs to use offline push.
  ///
  /// When to call /Trigger: To apply for push permission, note that this method will only pop up one push permission request to the user (if the user does not agree, then the user can only check the corresponding permission in the setting page), and the developer needs to choose an appropriate time to call.
  Future<void> applyNotificationPermission();

  ///Available since: 2.1.0 or later.
  ///
  ///Description: This method is used to register vendor offline push.
  ///
  /// Use cases: This method is called when a developer needs to use offline push.
  ///
  /// When to call /Trigger: It can be called when needed. There are no prerequisites.If you want to use voIP for iOS, you'll need to call [CallKit.setInitConfiguration] before doing so.
  Future<void> registerPush({ZPNsIOSEnvironment iOSEnvironment, ZPNsIOSNotificationArrivedConfig iOSNotificationArrivedConfig, bool enableIOSVoIP, ZPNsWebConfig webConfig});


  /// Available since: 2.5.0 or later.
  ///
  /// Description: Call this method to de-register when offline push is not required.
  ///
  /// Use cases: This method can be called to de-register when a user clicks a close message notification within the application.
  ///
  /// When to call /Trigger: Called when de-registration is required.
  ///
  /// Caution: It needs to be called after [registerPush] is called.
  Future<void> unregisterPush();

  /// iOS only
  /// Available since:ZPNs version 2.6.0 or later.
  ///
  /// Description:Reports the number of corners of the current App to the ZPNs server through this interface. When the app is offline, the ZPNs changes based on the previously reported corner mark number.
  ///
  /// Use cases: When the local corner of the developer is changed, this interface is called to report the change.
  ///
  /// Default value:If the receiver does not report the badge, the corner mark will not be modified when the push is sent.
  ///
  /// When to call /Trigger:It can be called at any time, but the actual time reported to the background is after pushID has successfully registered and the user has logged in, and before logging out.
  ///
  /// Restrictions: There is no single interface frequency limit.
  ///
  /// Caution:badge cannot be less than 0.
  Future<void> setServerBadge(int badge);

  /// Available since: ZPNs version 2.6.0 or later.
  ///
  /// Description: Set the number of app local corner markers.Supports Apple, Huawei, VIVO, and OPPO apis.
  ///
  /// Use cases: Called when the developer needs to modify the number of local corner markers.
  ///
  /// Default value: None.
  Future<void> setLocalBadge(int badge);
}
