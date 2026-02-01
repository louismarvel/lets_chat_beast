import 'package:flutter/services.dart';

import 'package:zego_plugin_adapter/src/signaling/enums.dart';

enum ZegoSignalingPluginInvitationMode {
  unknown,
  general,
  advanced,
}

/// @nodoc
/// room properties operation result
class ZegoSignalingPluginRoomPropertiesOperationResult {
  const ZegoSignalingPluginRoomPropertiesOperationResult({
    required this.errorKeys,
    this.error,
  });

  final PlatformException? error;
  final List<String> errorKeys;

  @override
  String toString() => '{errorKeys: $errorKeys, error: $error}';
}

/// @nodoc
/// connect user result
class ZegoSignalingPluginConnectUserResult {
  const ZegoSignalingPluginConnectUserResult({
    this.error,
  });

  final PlatformException? error;

  @override
  String toString() => '{error: $error}';
}

/// @nodoc
/// disconnect user result
class ZegoSignalingPluginDisconnectUserResult {
  const ZegoSignalingPluginDisconnectUserResult({
    required this.timeout,
  });

  final bool timeout;

  @override
  String toString() => '{timeout: $timeout}';
}

/// @nodoc
/// renew token result
class ZegoSignalingPluginRenewTokenResult {
  const ZegoSignalingPluginRenewTokenResult({
    this.error,
  });

  final PlatformException? error;

  @override
  String toString() => '{error: $error}';
}

/// @nodoc
/// invitation result
class ZegoSignalingPluginInvitationResult {
  const ZegoSignalingPluginInvitationResult({
    this.error,
    required this.invitationID,
    required this.errorInvitees,
  });

  final PlatformException? error;
  final String invitationID;
  final List<String> errorInvitees;

  @override
  String toString() => '{error: $error, '
      'invitationID: $invitationID, '
      'errorInvitees: $errorInvitees}';
}

/// @nodoc
/// set user in-room attributes result
class ZegoSignalingPluginSetUsersInRoomAttributesResult {
  const ZegoSignalingPluginSetUsersInRoomAttributesResult({
    this.error,
    required this.errorUserList,
    required this.attributes,
    required this.errorKeys,
  });

  final PlatformException? error;
  final List<String> errorUserList;

  // key: userID, value: attributes
  final Map<String, Map<String, String>> attributes;

  // key: userID, value: error keys
  final Map<String, List<String>> errorKeys;

  @override
  String toString() => '{error: $error, '
      'errorUserList: $errorUserList, '
      'attributes: $attributes, '
      'errorKeys: $errorKeys}';
}

/// @nodoc
/// end room batch operation result
class ZegoSignalingPluginEndRoomBatchOperationResult {
  const ZegoSignalingPluginEndRoomBatchOperationResult({
    this.error,
  });

  final PlatformException? error;

  @override
  String toString() => '{error: $error}';
}

/// @nodoc
/// query room properties result
class ZegoSignalingPluginQueryRoomPropertiesResult {
  const ZegoSignalingPluginQueryRoomPropertiesResult({
    this.error,
    required this.properties,
  });

  final PlatformException? error;
  final Map<String, String> properties;

  @override
  String toString() => '{error: $error, '
      'properties: $properties}';
}

/// @nodoc
/// query user in-room attributes result
class ZegoSignalingPluginQueryUsersInRoomAttributesResult {
  const ZegoSignalingPluginQueryUsersInRoomAttributesResult({
    this.error,
    required this.nextFlag,
    required this.attributes,
  });

  final PlatformException? error;

  // key: userID, value: attributes
  final Map<String, Map<String, String>> attributes;
  final String nextFlag;

  @override
  String toString() => '{error: $error, '
      'nextFlag: $nextFlag, '
      'attributes: $attributes}';
}

/// @nodoc
/// Description:Offline push configuration.
class ZegoSignalingPluginPushConfig {
  const ZegoSignalingPluginPushConfig({
    this.resourceID = '',
    this.title = '',
    this.message = '',
    this.payload = '',
    this.voipConfig,
  });

  final String resourceID;

  /// Description: Used to set the push title.
  final String title;

  /// Description: Used to set offline push content.
  final String message;

  /// Description: This parameter is used to set the pass-through field of offline push.
  final String payload;

  final ZegoSignalingPluginVoIPConfig? voipConfig;

  @override
  String toString() => '{'
      'title: $title, '
      'message: $message, '
      'payload: $payload, '
      'resourceID: $resourceID, '
      'voipConfig:$voipConfig'
      '}';
}

class ZegoSignalingPluginVoIPConfig {
  final bool iOSVoIPHasVideo;

  const ZegoSignalingPluginVoIPConfig({
    this.iOSVoIPHasVideo = false,
  });

  @override
  String toString() => '{'
      'iOSVoIPHasVideo: $iOSVoIPHasVideo, '
      '}';
}

/// @nodoc
/// send invitation result
class ZegoSignalingPluginSendInvitationResult {
  const ZegoSignalingPluginSendInvitationResult({
    this.error,
    required this.invitationID,
    required this.errorInvitees,
  });

  final PlatformException? error;
  final String invitationID;
  final Map<String, int /*reason*/ > errorInvitees;

  @override
  String toString() => '{error: $error, '
      'invitationID: $invitationID, '
      'errorInvitees: $errorInvitees}';
}

/// @nodoc
/// join invitation result
class ZegoSignalingPluginJoinInvitationResult {
  const ZegoSignalingPluginJoinInvitationResult({
    required this.invitationID,
    this.callUserList = const [],
    this.extendedData = '',
    this.createTime = 0,
    this.joinTime = 0,
    this.error,
  });

  final String invitationID;
  final String extendedData;
  final int createTime;
  final int joinTime;
  final List<ZegoSignalingPluginInvitationUserInfo> callUserList;
  final PlatformException? error;

  @override
  String toString() => '{'
      'invitationID: $invitationID, '
      'extendedData: $extendedData, '
      'createTime: $createTime, '
      'joinTime: $joinTime, '
      'callUserList: $callUserList, '
      '}';
}

/// end invitation result
class ZegoSignalingPluginEndInvitationResult {
  const ZegoSignalingPluginEndInvitationResult({
    this.invitationID = '',
    this.createTime = 0,
    this.acceptTime = 0,
    this.endTime = 0,
    this.error,
  });

  final int createTime;

  final int acceptTime;

  final int endTime;

  final String invitationID;

  final PlatformException? error;

  @override
  String toString() => '{'
      'createTime: $createTime, '
      'acceptTime: $acceptTime, '
      'endTime: $endTime, '
      'invitationID: $invitationID, '
      'error:error, '
      '}';
}

/// quit invitation result
class ZegoSignalingPluginQuitInvitationResult {
  const ZegoSignalingPluginQuitInvitationResult({
    this.invitationID = '',
    this.createTime = 0,
    this.acceptTime = 0,
    this.quitTime = 0,
    this.error,
  });

  final int createTime;

  final int acceptTime;

  final int quitTime;

  final String invitationID;
  final PlatformException? error;

  @override
  String toString() => '{'
      'createTime: $createTime, '
      'acceptTime: $acceptTime, '
      'quitTime: $quitTime, '
      'invitationID: $invitationID, '
      'error:$error, '
      '}';
}

/// @nodoc
/// cancel invitation result
class ZegoSignalingPluginCancelInvitationResult {
  const ZegoSignalingPluginCancelInvitationResult({
    required this.invitationID,
    required this.errorInvitees,
    this.error,
  });

  final String invitationID;
  final PlatformException? error;
  final List<String> errorInvitees;

  @override
  String toString() => '{error: $error, '
      'errorInvitees: $errorInvitees}';
}

/// @nodoc
/// response invitation result
class ZegoSignalingPluginResponseInvitationResult {
  const ZegoSignalingPluginResponseInvitationResult({
    required this.invitationID,
    this.error,
  });

  final String invitationID;
  final PlatformException? error;

  @override
  String toString() => '{error: $error}';
}

/// @nodoc
/// join room result
class ZegoSignalingPluginJoinRoomResult {
  const ZegoSignalingPluginJoinRoomResult({
    this.error,
  });

  final PlatformException? error;

  @override
  String toString() => '{error: $error}';
}

/// @nodoc
/// leave room result
class ZegoSignalingPluginLeaveRoomResult {
  const ZegoSignalingPluginLeaveRoomResult({
    this.error,
  });

  final PlatformException? error;

  @override
  String toString() => '{error: $error}';
}

/// @nodoc
/// error event
class ZegoSignalingPluginErrorEvent {
  ZegoSignalingPluginErrorEvent({
    required this.code,
    required this.message,
  });

  final int code;
  final String message;

  @override
  String toString() => '{code: $code, message: $message}';
}

/// @nodoc
/// connection state changed event
class ZegoSignalingPluginConnectionStateChangedEvent {
  const ZegoSignalingPluginConnectionStateChangedEvent({
    required this.state,
    required this.action,
    required this.extendedData,
  });

  final ZegoSignalingPluginConnectionState state;
  final ZegoSignalingPluginConnectionAction action;
  final Map<dynamic, dynamic> extendedData;

  @override
  String toString() => '{state: $state, '
      'action: $action, '
      'extendedData: $extendedData}';
}

/// @nodoc
/// token will expire event
class ZegoSignalingPluginTokenWillExpireEvent {
  const ZegoSignalingPluginTokenWillExpireEvent({
    required this.second,
  });

  final int second;

  @override
  String toString() => '{second: $second}';
}

/// @nodoc
/// incoming invitation received event
class ZegoSignalingPluginIncomingInvitationReceivedEvent {
  const ZegoSignalingPluginIncomingInvitationReceivedEvent({
    required this.invitationID,
    required this.inviterID,
    required this.timeoutSecond,
    required this.extendedData,
    required this.mode,
    required this.createTime,
    required this.callUserList,
  });

  final String invitationID;
  final String inviterID;
  final int timeoutSecond;
  final String extendedData;
  final int createTime;
  final ZegoSignalingPluginInvitationMode mode;
  final List<ZegoSignalingPluginInvitationUserInfo> callUserList;

  @override
  String toString() => '{invitationID: $invitationID, '
      'mode:$mode, '
      'inviterID: $inviterID, '
      'timeoutSecond: $timeoutSecond, '
      'createTime:$createTime, '
      'callUserList:$callUserList, '
      'extendedData: $extendedData}';
}

/// Description:Offline push configuration for cancel invitation
class ZegoSignalingPluginIncomingInvitationCancelPushConfig {
  /// Description: Used to set the push title.
  String title;

  /// Description: Used to set offline push content.
  String content;

  /// Description: This parameter is used to set the pass-through field of offline push.
  String payload;

  final String resourcesID;

  ZegoSignalingPluginIncomingInvitationCancelPushConfig({
    this.title = '',
    this.content = '',
    this.payload = '',
    this.resourcesID = '',
  });

  @override
  String toString() {
    return 'title:$title, content:$content, payload:$payload, resourcesID:$resourcesID';
  }
}

/// @nodoc
/// incoming invitation canceled event
class ZegoSignalingPluginIncomingInvitationCancelledEvent {
  const ZegoSignalingPluginIncomingInvitationCancelledEvent({
    required this.invitationID,
    required this.inviterID,
    required this.extendedData,
    required this.mode,
  });

  final String invitationID;
  final String inviterID;
  final String extendedData;
  final ZegoSignalingPluginInvitationMode mode;

  @override
  String toString() => '{invitationID: $invitationID, '
      'mode:$mode, '
      'inviterID: $inviterID, '
      'extendedData: $extendedData}';
}

/// @nodoc
/// outgoing invitation accepted event
class ZegoSignalingPluginOutgoingInvitationAcceptedEvent {
  const ZegoSignalingPluginOutgoingInvitationAcceptedEvent({
    required this.invitationID,
    required this.inviteeID,
    required this.extendedData,
  });

  final String invitationID;
  final String inviteeID;
  final String extendedData;

  @override
  String toString() => '{invitationID: $invitationID, '
      'inviteeID: $inviteeID, '
      'extendedData: $extendedData}';
}

/// @nodoc
class ZegoSignalingPluginOutgoingInvitationRejectedEvent {
  const ZegoSignalingPluginOutgoingInvitationRejectedEvent({
    required this.invitationID,
    required this.inviteeID,
    required this.extendedData,
  });

  final String invitationID;
  final String inviteeID;
  final String extendedData;

  @override
  String toString() => '{invitationID: $invitationID, '
      'inviteeID: $inviteeID, '
      'extendedData: $extendedData}';
}

/// @nodoc
class ZegoSignalingPluginOutgoingInvitationEndedEvent {
  const ZegoSignalingPluginOutgoingInvitationEndedEvent({
    required this.invitationID,
    required this.callerID,
    required this.operatedUserID,
    required this.endTime,
    required this.extendedData,
    required this.mode,
  });

  final String invitationID;
  final String callerID;
  final String operatedUserID;
  final String extendedData;
  final int endTime;
  final ZegoSignalingPluginInvitationMode mode;

  @override
  String toString() => '{invitationID: $invitationID, '
      'mode:$mode, '
      'callerID: $callerID, '
      'operatedUserID: $operatedUserID, '
      'endTime: $endTime, '
      'extendedData: $extendedData}';
}

/// Call invitation user state.
enum ZegoSignalingPluginInvitationUserState {
  unknown,
  inviting,
  accepted,
  rejected,
  cancelled,
  offline,
  received,
  timeout,
  quited,
  ended,
  notYetReceived,
  beCanceled,
}

class ZegoSignalingPluginInvitationUserStateChangedEvent {
  final String invitationID;
  final List<ZegoSignalingPluginInvitationUserInfo> callUserList;

  /// invitation type use by prebuilt
  //
  // call
  // ZegoCallInvitationType.voiceCall: 0,
  // ZegoCallInvitationType.videoCall: 1,
  //
  // live streaming
  // ZegoLiveStreamingInvitationType.requestCoHost: 2,
  // ZegoLiveStreamingInvitationType.inviteToJoinCoHost: 3,
  // ZegoLiveStreamingInvitationType.removeFromCoHost: 4,
  // // ZegoLiveStreamingInvitationType.crossRoomPKBattleRequest: 5,
  // ZegoLiveStreamingInvitationType.crossRoomPKBattleRequestV2: 6,
  int type;

  ZegoSignalingPluginInvitationUserStateChangedEvent({
    required this.invitationID,
    required this.callUserList,
    this.type = -1,
  });

  @override
  String toString() {
    return '{invitationID:$invitationID, callUserList:$callUserList}';
  }
}

/// Call invitation user information.
class ZegoSignalingPluginInvitationUserInfo {
  /// Description:  userID.
  final String userID;

  /// Description:  user status.
  final ZegoSignalingPluginInvitationUserState state;

  final String extendedData;

  ZegoSignalingPluginInvitationUserInfo({
    this.userID = '',
    this.state = ZegoSignalingPluginInvitationUserState.inviting,
    this.extendedData = '',
  });

  @override
  String toString() {
    return '{userID:$userID, state:$state, extended data:$extendedData}';
  }
}

/// @nodoc
class ZegoSignalingPluginIncomingInvitationTimeoutEvent {
  const ZegoSignalingPluginIncomingInvitationTimeoutEvent({
    required this.invitationID,
    required this.mode,
  });

  final String invitationID;
  final ZegoSignalingPluginInvitationMode mode;

  @override
  String toString() => '{invitationID: $invitationID, '
      'mode:$mode}';
}

/// @nodoc
class ZegoSignalingPluginOutgoingInvitationTimeoutEvent {
  const ZegoSignalingPluginOutgoingInvitationTimeoutEvent({
    required this.invitationID,
    required this.invitees,
  });

  final String invitationID;
  final List<String> invitees;

  @override
  String toString() => '{invitationID: $invitationID, invitees: $invitees}';
}

/// @nodoc
class ZegoSignalingPluginRoomStateChangedEvent {
  const ZegoSignalingPluginRoomStateChangedEvent({
    required this.roomID,
    required this.state,
    required this.action,
    required this.extendedData,
  });

  final String roomID;
  final ZegoSignalingPluginRoomState state;
  final ZegoSignalingPluginRoomAction action;
  final Map<dynamic, dynamic> extendedData;

  @override
  String toString() => '{roomID: $roomID, '
      'state: $state, '
      'action: $action, '
      'extendedData: $extendedData}';
}

/// @nodoc
class ZegoSignalingPluginRoomPropertiesBatchUpdatedEvent {
  const ZegoSignalingPluginRoomPropertiesBatchUpdatedEvent({
    required this.roomID,
    required this.setProperties,
    required this.deleteProperties,
  });

  final String roomID;
  final Map<String, String> setProperties;
  final Map<String, String> deleteProperties;

  @override
  String toString() => '{roomID: $roomID, '
      'setProperties: $setProperties, '
      'deleteProperties: $deleteProperties}';
}

/// @nodoc
class ZegoSignalingPluginRoomPropertiesUpdatedEvent {
  const ZegoSignalingPluginRoomPropertiesUpdatedEvent({
    required this.roomID,
    required this.setProperties,
    required this.deleteProperties,
  });

  final String roomID;
  final Map<String, String> setProperties;
  final Map<String, String> deleteProperties;

  @override
  String toString() => '{roomID: $roomID, '
      'setProperties: $setProperties, '
      'deleteProperties: $deleteProperties}';
}

/// @nodoc
class ZegoSignalingPluginUsersInRoomAttributesUpdatedEvent {
  const ZegoSignalingPluginUsersInRoomAttributesUpdatedEvent({
    required this.attributes,
    required this.editorID,
    required this.roomID,
  });

  // key: userID, value: attributes
  final Map<String, Map<String, String>> attributes;
  final String editorID;
  final String roomID;

  @override
  String toString() => '{attributes: $attributes, '
      'editorID: $editorID, '
      'roomID: $roomID}';
}

/// @nodoc
class ZegoSignalingPluginRoomMemberJoinedEvent {
  const ZegoSignalingPluginRoomMemberJoinedEvent({
    required this.usersID,
    required this.usersName,
    required this.roomID,
  });

  final List<String> usersID;
  final List<String> usersName;
  final String roomID;

  @override
  String toString() => '{usersID: $usersID, '
      'usersName: $usersName, '
      'roomID: $roomID}';
}

/// @nodoc
class ZegoSignalingPluginRoomMemberLeftEvent {
  const ZegoSignalingPluginRoomMemberLeftEvent({
    required this.usersID,
    required this.usersName,
    required this.roomID,
  });

  final List<String> usersID;
  final List<String> usersName;
  final String roomID;

  @override
  String toString() => '{usersID: $usersID, '
      'usersName: $usersName, '
      'roomID: $roomID}';
}

/// @nodoc
class ZegoSignalingPluginNotificationRegisteredEvent {
  ZegoSignalingPluginNotificationRegisteredEvent({
    required this.pushID,
    required this.code,
  });

  final String pushID;
  final int code;

  @override
  String toString() => '{pushID: $pushID, '
      'code: $code}';
}

/// @nodoc
class ZegoSignalingPluginNotificationArrivedEvent {
  ZegoSignalingPluginNotificationArrivedEvent({
    required this.title,
    required this.content,
    required this.extras,
  });

  final String title;
  final String content;
  final Map<String, Object?> extras;

  @override
  String toString() => '{title: $title, '
      'content: $content, '
      'extras: $extras}';
}

/// @nodoc
class ZegoSignalingPluginNotificationClickedEvent {
  ZegoSignalingPluginNotificationClickedEvent({
    required this.title,
    required this.content,
    required this.extras,
  });

  final String title;
  final String content;
  final Map<String, Object?> extras;

  @override
  String toString() => '{title: $title, '
      'content: $content, '
      'extras: $extras}';
}

/// @nodoc
class ZegoSignalingPluginThroughMessageReceivedEvent {
  ZegoSignalingPluginThroughMessageReceivedEvent({
    required this.title,
    required this.content,
    required this.extras,
  });

  final String title;
  final String content;
  final Map<String, Object> extras;

  @override
  String toString() => '{title: $title, '
      'content: $content, '
      'extras: $extras}';
}

/// @nodoc
class ZegoSignalingPluginInRoomTextMessageResult {
  const ZegoSignalingPluginInRoomTextMessageResult({
    this.error,
  });

  final PlatformException? error;

  @override
  String toString() => '{error: $error}';
}

class ZegoSignalingPluginInRoomCommandMessageResult {
  const ZegoSignalingPluginInRoomCommandMessageResult({
    this.error,
  });

  final PlatformException? error;

  @override
  String toString() => '{error: $error}';
}

/// @nodoc
class ZegoSignalingPluginEnableNotifyResult {
  const ZegoSignalingPluginEnableNotifyResult({
    this.error,
  });

  final PlatformException? error;

  @override
  String toString() => '{error: $error}';
}

/// @nodoc
class ZegoSignalingPluginInRoomTextMessage {
  ZegoSignalingPluginInRoomTextMessage({
    required this.text,
    required this.senderUserID,
    required this.orderKey,
    required this.timestamp,
  });

  final String text;
  final String senderUserID;
  final int timestamp;
  final int orderKey;

  @override
  String toString() => '{text: $text, '
      'senderUserID: $senderUserID, '
      'timestamp: $timestamp, '
      'orderKey: $orderKey}';
}

/// @nodoc
class ZegoSignalingPluginInRoomTextMessageReceivedEvent {
  ZegoSignalingPluginInRoomTextMessageReceivedEvent({
    required this.messages,
    required this.roomID,
  });

  final List<ZegoSignalingPluginInRoomTextMessage> messages;
  final String roomID;

  @override
  String toString() => '{messages: $messages, '
      'roomID: $roomID}';
}

/// @nodoc
class ZegoSignalingPluginInRoomCommandMessage {
  ZegoSignalingPluginInRoomCommandMessage({
    required this.message,
    required this.senderUserID,
    required this.orderKey,
    required this.timestamp,
  });

  /// If you have a string encoded in UTF-8 and want to convert a Uint8List
  /// to that string, you can use the following method:
  ///
  /// import 'dart:convert';
  /// import 'dart:typed_data';
  ///
  /// String result = utf8.decode(commandMessage.message); // Convert the Uint8List to a string
  ///
  final Uint8List message;

  final String senderUserID;
  final int timestamp;
  final int orderKey;

  @override
  String toString() => '{message: $message, '
      'senderUserID: $senderUserID, '
      'timestamp: $timestamp, '
      'orderKey: $orderKey}';
}

/// @nodoc
class ZegoSignalingPluginInRoomCommandMessageReceivedEvent {
  ZegoSignalingPluginInRoomCommandMessageReceivedEvent({
    required this.messages,
    required this.roomID,
  });

  final List<ZegoSignalingPluginInRoomCommandMessage> messages;
  final String roomID;

  @override
  String toString() => '{messages: $messages, '
      'roomID: $roomID}';
}

/// @nodoc
class ZegoSignalingPluginSetMessageHandlerResult {
  const ZegoSignalingPluginSetMessageHandlerResult({
    this.error,
  });

  final PlatformException? error;

  @override
  String toString() => '{error: $error}';
}

/// @nodoc
class ZegoSignalingPluginProviderConfiguration {
  /// Localized name of the provider
  String localizedName;

  /// Image should be a square with side length of 40 points
  String iconTemplateImageName;

  /// Default NO
  bool supportsVideo;

  /// Default 5
  int maximumCallsPerCallGroup;

  /// Default 2
  int maximumCallGroups;

  ZegoSignalingPluginProviderConfiguration({
    required this.localizedName,
    required this.iconTemplateImageName,
    this.supportsVideo = false,
    this.maximumCallsPerCallGroup = 1,
    this.maximumCallGroups = 1,
  });

  @override
  String toString() {
    return 'localized name:$localizedName, '
        'icon template image name:$iconTemplateImageName, '
        'supports video:$supportsVideo, '
        'maximum calls per call group:$maximumCallsPerCallGroup, '
        'maximum call groups:$maximumCallGroups';
  }
}

/// @nodoc
/// Custom push source type enum to avoid dependency on zego_zpns
enum ZegoSignalingPluginPushSourceType {
  apns,
  zego,
  fcm,
  huaWei,
  xiaoMi,
  oppo,
  vivo
}

/// @nodoc
/// Custom message class to avoid dependency on zego_zpns
class ZegoSignalingPluginMessage {
  String title = "";
  String content = "";
  String payload = "";
  Map<String, Object?> extras = {};
  ZegoSignalingPluginPushSourceType pushSourceType;

  ZegoSignalingPluginMessage({required this.pushSourceType});

  /// Convert from zego_zpns ZPNsMessage if needed
  factory ZegoSignalingPluginMessage.fromZPNsMessage(dynamic zpnsMessage) {
    // This is a placeholder - you can implement conversion logic if needed
    return ZegoSignalingPluginMessage(
      pushSourceType: ZegoSignalingPluginPushSourceType.zego,
    );
  }
}

/// @nodoc
/// Custom background message handler to avoid dependency on zego_zpns
/// Note: This should be compatible with the original ZPNsBackgroundMessageHandler
typedef ZegoSignalingPluginZPNsBackgroundMessageHandler = Future<void> Function(
    ZegoSignalingPluginMessage message);

/// @nodoc
/// Custom through message handler to avoid dependency on zego_zpns
/// Note: This should be compatible with the original ZPNsThroughMessageHandler
typedef ZegoSignalingPluginZPNsThroughMessageHandler = void Function(
    ZegoSignalingPluginMessage message);
