part of '../interface.dart';

/// @nodoc
mixin ZegoSignalingPluginUserAPI {
  /// login
  Future<ZegoSignalingPluginConnectUserResult> connectUser({
    required String id,
    String name = '',
    String token = '',
  });

  /// logout
  Future<ZegoSignalingPluginDisconnectUserResult> disconnectUser();

  /// renewToken
  Future<ZegoSignalingPluginRenewTokenResult> renewToken(String token);
}

/// @nodoc
mixin ZegoSignalingPluginUserEvent {
  /// Connection State
  ZegoSignalingPluginConnectionState getConnectionState();

  /// Connection State Changed Event Stream
  Stream<ZegoSignalingPluginConnectionStateChangedEvent>
      getConnectionStateChangedEventStream();

  /// Token Will Expire Event Stream
  Stream<ZegoSignalingPluginTokenWillExpireEvent>
      getTokenWillExpireEventStream();
}
