part of '../interface.dart';

/// @nodoc
mixin ZegoSignalingPluginCallKitAPI {
  /// set Incoming Push Received Handler
  Future<void> setIncomingPushReceivedHandler(
    ZegoSignalingIncomingPushReceivedHandler handler,
  );

  /// set Init Configuration
  Future<void> setInitConfiguration(
    ZegoSignalingPluginProviderConfiguration configuration,
  );

  /// report Call Ended
  Future<void> reportCallEnded(
      ZegoSignalingPluginCXCallEndedReason endedReason, String uuid);
}

/// @nodoc
mixin ZegoSignalingPluginCallKitEvent {
  /// Called when the provider has been reset. Delegates must respond to this callback by cleaning up all internal call state (disconnecting communication channels, releasing network resources, etc.). This callback can be treated as a request to end all calls without the need to respond to any actions
  Stream<ZegoSignalingPluginCallKitVoidEvent>
      getCallkitProviderDidResetEventStream();

  /// Called when the provider has been fully created and is ready to send actions and receive updates
  Stream<ZegoSignalingPluginCallKitVoidEvent>
      getCallkitProviderDidBeginEventStream();

  /// Called when the provider's audio session activation state changes.
  Stream<ZegoSignalingPluginCallKitVoidEvent>
      getCallkitActivateAudioEventStream();

  Stream<ZegoSignalingPluginCallKitVoidEvent>
      getCallkitDeactivateAudioEventStream();

  /// Called when an action was not performed in time and has been inherently failed. Depending on the action, this timeout may also force the call to end. An action that has already timed out should not be fulfilled or failed by the provider delegate
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitTimedOutPerformingActionEventStream();

  /// each perform CallAction method is called sequentially for each action in the transaction
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformStartCallActionEventStream();

  /// Callkit Perform Answer Call Action Event Stream
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformAnswerCallActionEventStream();

  /// Callkit Perform End Call Action Event Stream
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformEndCallActionEventStream();

  /// Callkit Perform Set Held Call Action Event Stream
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformSetHeldCallActionEventStream();

  /// Callkit Perform Set Muted Call Action Event Stream
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformSetMutedCallActionEventStream();

  /// Callkit Perform Set Group Call Action Event Stream
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformSetGroupCallActionEventStream();

  /// Callkit Perform Play DTMF Call Action Event Stream
  Stream<ZegoSignalingPluginCallKitActionEvent>
      getCallkitPerformPlayDTMFCallActionEventStream();
}
