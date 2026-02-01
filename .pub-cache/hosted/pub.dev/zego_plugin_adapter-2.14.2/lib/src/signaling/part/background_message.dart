part of '../interface.dart';

/// @nodoc
mixin ZegoSignalingPluginBackgroundMessageAPI {
  Future<void> removeBackgroundMessageHandler({String key = ''});

  /// set Background Message Handler
  Future<ZegoSignalingPluginSetMessageHandlerResult>
      setBackgroundMessageHandler(
    ZegoSignalingPluginZPNsBackgroundMessageHandler handler, {
    String key = 'default',
  });

  /// set Through Message Handler
  Future<ZegoSignalingPluginSetMessageHandlerResult> setThroughMessageHandler(
    ZegoSignalingPluginZPNsThroughMessageHandler? handler,
  );
}

/// @nodoc
mixin ZegoSignalingPluginBackgroundMessageEvent {}
