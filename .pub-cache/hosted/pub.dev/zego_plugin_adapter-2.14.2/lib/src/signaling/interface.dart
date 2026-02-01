import 'dart:core';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

import 'package:zego_plugin_adapter/src/defines.dart';
import 'package:zego_plugin_adapter/src/signaling/callkit_defines.dart';
import 'package:zego_plugin_adapter/src/signaling/defines.dart';
import 'package:zego_plugin_adapter/src/signaling/enums.dart';
import 'package:zego_plugin_adapter/src/signaling/errors.dart';

part 'part/background_message.dart';

part 'part/callkit.dart';

part 'part/invitation.dart';

part 'part/message.dart';

part 'part/notification.dart';

part 'part/room.dart';

part 'part/user.dart';

/// @nodoc
/// For all apis and events, See mixins.
abstract class ZegoSignalingPluginInterface
    with
        ZegoSignalingPluginRoomAPI,
        ZegoSignalingPluginRoomEvent,
        ZegoSignalingPluginInvitationAPI,
        ZegoSignalingPluginInvitationEvent,
        ZegoSignalingPluginUserAPI,
        ZegoSignalingPluginUserEvent,
        ZegoSignalingPluginNotificationAPI,
        ZegoSignalingPluginNotificationEvent,
        ZegoSignalingPluginMessageAPI,
        ZegoSignalingPluginMessageEvent,
        ZegoSignalingPluginBackgroundMessageAPI,
        ZegoSignalingPluginBackgroundMessageEvent,
        ZegoSignalingPluginCallKitAPI,
        ZegoSignalingPluginCallKitEvent,
        IZegoUIKitPlugin {
  /// init
  Future<void> init({required int appID, String appSign = ''});

  /// uninit
  Future<void> uninit();

  /// get error event stream from zim
  Stream<ZegoSignalingPluginErrorEvent> getErrorEventStream();

  /// get error stream
  Stream<ZegoSignalingError> getErrorStream();
}
