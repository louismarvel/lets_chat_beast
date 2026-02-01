part of '../interface.dart';

/// @nodoc
mixin ZegoSignalingPluginNotificationAPI {
  /// enable Notify When App Running In Background Or Quit
  Future<ZegoSignalingPluginEnableNotifyResult>
      enableNotifyWhenAppRunningInBackgroundOrQuit({
    bool? isIOSSandboxEnvironment,
    bool enableIOSVoIP = true,
    ZegoSignalingPluginMultiCertificate certificateIndex =
        ZegoSignalingPluginMultiCertificate.firstCertificate,
    String appName = '',
    String androidChannelID = '',
    String androidChannelName = '',
    String androidSound = '',
  });
}

/// @nodoc
mixin ZegoSignalingPluginNotificationEvent {
  /// get Notification Registered Event Stream
  Stream<ZegoSignalingPluginNotificationRegisteredEvent>
      getNotificationRegisteredEventStream();

  /// get Notification Arrived Event Stream
  Stream<ZegoSignalingPluginNotificationArrivedEvent>
      getNotificationArrivedEventStream();

  /// get Notification Clicked Event Stream
  Stream<ZegoSignalingPluginNotificationClickedEvent>
      getNotificationClickedEventStream();
}
