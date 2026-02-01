## 2.8.0
### New Features:
Now you can access push vendors according to your needs
## 2.6.0
### New Features:
- Custom Notification Icon: Beyond the default display of the APP icon in offline push notifications, ZPNs now enables customization of the notification icon. This feature can be used to include the sender's avatar in pushed notifications for individual or group chat messages. For more details, please refer to the "Custom Notification Icon" documentation. 
- Notification with Image: The update introduces support for including an image in offline push notifications. For more information, please refer to the "Notification with Image" section.
- Update Icon Badge: This version allows for updating the app icon badge in offline scenarios, helping to alert users about the number of unread messages. More information can be found in the "Update Icon Badge" documentation.
- Replace Notification: There is now support for withdrawing previously pushed notifications. For more details, please refer to the "Replace Notification" section.
For further information and guidance on these new features, please refer to the respective sections in the documentation.
### API Refactoring
> 💥 ZPNs 2.6.0 has separated CallKit into an independent plugin. If your project was using an older version of ZPNs, after upgrading, you will need to integrate the zego_callkit plugin additionally to ensure compatibility.
Importing the zego_callkit Plugin
Open the "pubspec.yaml" file and add the "zego_callkit" dependency in the format of "pub":
    zego_callkit: ^x.y.z
Depend on the new header file for compatibility with the upgrade:
    import 'package:zego_callkit/zego_callkit.dart';

## 2.5.0

New Features:
- Web Development: Support developing web applications using the Flutter framework, and implement offline push. For more details, please refer to Implementation of Offline Push - Web Integration Process.
- Local Logs: Added ZPNs local log component, which can upload logs of both ZIM and ZPNs by calling the uploadLog function in the ZIM SDK.
- Push Unregistration: Support unregistering offline push and disabling push notifications in mobile applications. Please refer to unregisterPush for more details.
- iOS Push Display Settings: Added the iOSNotificationArrivedConfig parameter in registerPush, which allows specifying whether to display iOS push alerts, sounds, and badges during offline push registration.
- Pushing Private Messages to Android Devices: Support pushing messages via the private message channels provided by Android device manufacturers, achieving unlimited push capability. Please refer to the relevant content in the integration guides for Xiaomi, Huawei, OPPO, and vivo on how to create private message channels.
- iOS Environment: Added the Automatic option in the ZPNsIOSEnvironment enumeration. When developers call registerPush for offline push registration and are not familiar with the iOS environment, they can pass this enumeration and ZPNs will automatically recognize the environment.
- Initiating iOS Callkit Call Interface: Added an interface 'reportIncomingCall'.

Interface Changes:
- Data Class Member Variable Type Change: The type of the extras in ZPNsMessage has been changed from Map<String, Object> to Map<String, Object?>, in order to accommodate cases where the value may be null during JSON to map conversion. For more details, please refer to ZPNs Upgrade Guide - 2.5.0 Upgrade Guide.

## 2.4.0+1

### Fix a known problem

## 2.4.0

### Supports offline push between two apps

## 2.3.2+1

### Fix a known problem

## 2.3.2

### API Refactoring
> 💥 Function(CXAction action)? performSetMutedCallAction =》 Function(CXSetMutedCallAction action)? performSetMutedCallAction
### Fix a known problem

## 2.3.1+2

### Fix a known problem

## 2.3.1+1

### Fix a known problem

## 2.3.1

### API Refactoring
> 💥 New setBackgroundMessageHandler interface used to set up the android silent push triggered the callback.Renamed didReceiveIncomingPush didReceiveIncomingPushWithPayload method, parameters by a change in content and completion for extras and uuid.

### Fix a known problem

## 2.3.0+1

### Fix a known problem

## 2.3.0

### iOS platform support VoIP 和 background push type.
### Android platform support FCM Data Message


## 2.2.0
### API Refactoring
> 💥 Please note to developers that there are breaking changes starting from version 2.2.0, so please read the following guidelines when upgrading from the old version to the new version.

#### 1. Make `create` function from member function to static function, and changing the return value from `Future<ZPNs>` to `ZPNs?`. When you using ZPNs,make sure has been configured by static function set then please call this API first. Also, you should remove the keyword `await`.

#### 2. Remove unnecessary Future return values ​​from some APIs, so you don't need to `await` the retuen value. 

## 2.1.3

- Fixed a bug about meet android-12 request.

## 2.1.2

- Fixed a bug about android dependency.

## 2.1.1

- Fixed a bug about android extendedData error.

## 2.1.0

- Release version, with native iOS SDK dependency version 2.0.1, android SDK dependency version 2.1.0.

## 0.1.2

- Test version, with native iOS SDK dependency version 2.0.1, android SDK dependency version 2.1.0.

## 0.1.1

- Test version, with native iOS SDK dependency version 2.0.1, android SDK dependency version 2.1.0.

## 0.1.0

- Test version, with native iOS SDK dependency version 2.0.1, android SDK dependency version 2.1.0.

## 0.0.1

- Test version, with native iOS SDK dependency version 2.0.1, android SDK dependency version 2.1.0.
