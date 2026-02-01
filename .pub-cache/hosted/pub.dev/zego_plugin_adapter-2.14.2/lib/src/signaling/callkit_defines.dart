import 'package:flutter/foundation.dart';

/// @nodoc
class ZegoSignalingPluginCallKitIncomingPushReceivedEvent {
  Map<String, dynamic> extras;
  String uuid;

  ZegoSignalingPluginCallKitIncomingPushReceivedEvent({
    required this.extras,
    required this.uuid,
  });
}

/// @nodoc
class ZegoSignalingPluginCallKitVoidEvent {}

/// @nodoc
class ZegoSignalingPluginCallKitActionEvent {
  /// Action 的唯一标识符
  final String actionId;

  /// Action 类型
  final String actionType;

  /// Action 数据
  final dynamic actionData;

  /// 完成 Action 的回调函数
  final VoidCallback? fulfill;

  /// 失败 Action 的回调函数
  final VoidCallback? fail;

  ZegoSignalingPluginCallKitActionEvent({
    required this.actionId,
    required this.actionType,
    required this.actionData,
    this.fulfill,
    this.fail,
  });
}

/// @nodoc
class ZegoSignalingPluginCallKitSetMutedCallActionEvent {
  ZegoSignalingPluginCXSetMutedCallAction action;

  ZegoSignalingPluginCallKitSetMutedCallActionEvent({
    required this.action,
  });
}

/// @nodoc
/// Custom action abstract class to avoid dependency on zego_callkit
abstract class ZegoSignalingPluginCXAction {
  void fulfill();
  void fail();
}

/// @nodoc
/// Custom call action abstract class to avoid dependency on zego_callkit
abstract class ZegoSignalingPluginCXCallAction
    extends ZegoSignalingPluginCXAction {
  late String callUUID;
}

/// @nodoc
/// Custom start call action abstract class to avoid dependency on zego_callkit
abstract class ZegoSignalingPluginCXStartCallAction
    extends ZegoSignalingPluginCXCallAction {
  late ZegoSignalingPluginCXHandle handle;
  late String contactIdentifier;
  late bool video;
}

/// @nodoc
/// Custom answer call action abstract class to avoid dependency on zego_callkit
abstract class ZegoSignalingPluginCXAnswerCallAction
    extends ZegoSignalingPluginCXCallAction {}

/// @nodoc
/// Custom end call action abstract class to avoid dependency on zego_callkit
abstract class ZegoSignalingPluginCXEndCallAction
    extends ZegoSignalingPluginCXCallAction {}

/// @nodoc
/// Custom set held call action abstract class to avoid dependency on zego_callkit
abstract class ZegoSignalingPluginCXSetHeldCallAction
    extends ZegoSignalingPluginCXCallAction {
  late bool onHold;
}

/// @nodoc
/// Custom set muted call action abstract class to avoid dependency on zego_callkit
abstract class ZegoSignalingPluginCXSetMutedCallAction
    extends ZegoSignalingPluginCXCallAction {
  late bool muted;
}

/// @nodoc
/// Custom set group call action abstract class to avoid dependency on zego_callkit
abstract class ZegoSignalingPluginCXSetGroupCallAction
    extends ZegoSignalingPluginCXCallAction {}

/// @nodoc
/// Custom play DTMF call action abstract class to avoid dependency on zego_callkit
abstract class ZegoSignalingPluginCXPlayDTMFCallAction
    extends ZegoSignalingPluginCXCallAction {
  late String digits;
  late ZegoSignalingPluginCXPlayDTMFCallActionType type;
}

/// @nodoc
/// Custom call ended reason enum to avoid dependency on zego_callkit
enum ZegoSignalingPluginCXCallEndedReason {
  /// An error occurred while trying to service the call
  callEndedReasonFailed,

  /// The remote party explicitly ended the call
  callEndedReasonRemoteEnded,

  /// The call never started connecting and was never explicitly ended (e.g. outgoing/incoming call timeout)
  callEndedReasonUnanswered,

  /// The call was answered on another device
  callEndedReasonAnsweredElsewhere,

  /// The call was declined on another device
  callEndedReasonDeclinedElsewhere
}

/// @nodoc
/// Custom handle type enum to avoid dependency on zego_callkit
enum ZegoSignalingPluginCXHandleType {
  handleTypeGeneric,
  handleTypePhoneNumber,
  handleTypeEmailAddress
}

/// @nodoc
/// Custom play DTMF call action type enum to avoid dependency on zego_callkit
enum ZegoSignalingPluginCXPlayDTMFCallActionType {
  playDTMFCallActionTypeSingleTone,
  playDTMFCallActionTypeSoftPause,
  playDTMFCallActionTypeHardPause
}

/// @nodoc
/// Custom call update class to avoid dependency on zego_callkit
class ZegoSignalingPluginCXCallUpdate {
  /// Handle for the remote party (for an incoming call, the caller; for an outgoing call, the callee).
  ZegoSignalingPluginCXHandle? remoteHandle;

  /// Override the computed caller name to a provider-defined value.
  String? localizedCallerName;

  /// Whether the call can be held on its own or swapped with another call
  bool? supportsHolding;

  /// Whether the call can be grouped (merged) with other calls when it is ungrouped
  bool? supportsGrouping;

  /// The call can be ungrouped (taken private) when it is grouped
  bool? supportsUngrouping;

  /// The call can send DTMF tones via hard pause digits or in-call keypad entries
  bool? supportsDTMF;

  /// The call includes video in addition to audio.
  bool? hasVideo;

  ZegoSignalingPluginCXCallUpdate({
    this.remoteHandle,
    this.localizedCallerName,
    this.supportsHolding,
    this.supportsGrouping,
    this.supportsUngrouping,
    this.supportsDTMF,
    this.hasVideo,
  });
}

/// @nodoc
/// Custom handle class to avoid dependency on zego_callkit
class ZegoSignalingPluginCXHandle {
  ZegoSignalingPluginCXHandleType type;
  String value;
  ZegoSignalingPluginCXHandle({required this.type, required this.value});
}

/// @nodoc
typedef ZegoSignalingIncomingPushReceivedHandler = void Function(
    Map extras, String uuid);
