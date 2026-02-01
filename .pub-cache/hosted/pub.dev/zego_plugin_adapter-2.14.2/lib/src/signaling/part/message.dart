part of '../interface.dart';

/// @nodoc
mixin ZegoSignalingPluginMessageAPI {
  /// send In Room Text Message
  Future<ZegoSignalingPluginInRoomTextMessageResult> sendInRoomTextMessage({
    required String roomID,
    required String message,
  });

  /// send In Room Command Message
  Future<ZegoSignalingPluginInRoomCommandMessageResult>
      sendInRoomCommandMessage({
    required String roomID,
    required Uint8List message,
  });
}

/// @nodoc
mixin ZegoSignalingPluginMessageEvent {
  /// InRoom Text Message Received Event Stream
  Stream<ZegoSignalingPluginInRoomTextMessageReceivedEvent>
      getInRoomTextMessageReceivedEventStream();

  /// InRoom Command Message Received Event Stream
  Stream<ZegoSignalingPluginInRoomCommandMessageReceivedEvent>
      getInRoomCommandMessageReceivedEventStream();
}
