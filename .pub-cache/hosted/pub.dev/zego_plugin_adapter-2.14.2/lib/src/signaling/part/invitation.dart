part of '../interface.dart';

/// @nodoc
mixin ZegoSignalingPluginInvitationAPI {
  /// send Invitation
  Future<ZegoSignalingPluginSendInvitationResult> sendInvitation({
    required List<String> invitees,
    required int timeout,
    bool isAdvancedMode = false,
    String extendedData = '',
    ZegoSignalingPluginPushConfig? pushConfig,
  });

  /// add Invitation
  Future<ZegoSignalingPluginSendInvitationResult> addInvitation({
    required List<String> invitees,
    required String invitationID,
    ZegoSignalingPluginPushConfig? pushConfig,
  });

  /// join Invitation
  Future<ZegoSignalingPluginJoinInvitationResult> joinInvitation({
    required String invitationID,
    String extendedData = '',
  });

  /// cancel Invitation
  Future<ZegoSignalingPluginCancelInvitationResult> cancelInvitation({
    required String invitationID,
    required List<String> invitees,
    String extendedData = '',
    ZegoSignalingPluginIncomingInvitationCancelPushConfig? pushConfig,
  });

  /// refuse Invitation
  Future<ZegoSignalingPluginResponseInvitationResult> refuseInvitation({
    required String invitationID,
    String extendedData = '',
  });

  /// accept Invitation
  Future<ZegoSignalingPluginResponseInvitationResult> acceptInvitation({
    required String invitationID,
    String extendedData = '',
  });

  /// end Invitation
  Future<ZegoSignalingPluginEndInvitationResult> endInvitation({
    required String invitationID,
    String extendedData = '',
    ZegoSignalingPluginPushConfig? pushConfig,
  });

  /// quit Invitation
  Future<ZegoSignalingPluginQuitInvitationResult> quitInvitation({
    required String invitationID,
    String extendedData = '',
    ZegoSignalingPluginPushConfig? pushConfig,
  });
}

/// @nodoc
mixin ZegoSignalingPluginInvitationEvent {
  /// Invitation User State Changed Event Stream
  Stream<ZegoSignalingPluginInvitationUserStateChangedEvent>
      getInvitationUserStateChangedEventStream();

  /// Incoming Invitation Received Event Stream
  Stream<ZegoSignalingPluginIncomingInvitationReceivedEvent>
      getIncomingInvitationReceivedEventStream();

  /// Incoming Invitation Cancelled Event Stream
  Stream<ZegoSignalingPluginIncomingInvitationCancelledEvent>
      getIncomingInvitationCancelledEventStream();

  /// Outgoing Invitation Accepted Event Stream
  Stream<ZegoSignalingPluginOutgoingInvitationAcceptedEvent>
      getOutgoingInvitationAcceptedEventStream();

  /// Outgoing Invitation Rejected Event Stream
  Stream<ZegoSignalingPluginOutgoingInvitationRejectedEvent>
      getOutgoingInvitationRejectedEventStream();

  /// Outgoing Invitation Ended Event Stream
  Stream<ZegoSignalingPluginOutgoingInvitationEndedEvent>
      getOutgoingInvitationEndedEventStream();

  /// Incoming Invitation Timeout Event Stream
  Stream<ZegoSignalingPluginIncomingInvitationTimeoutEvent>
      getIncomingInvitationTimeoutEventStream();

  /// Outgoing Invitation Timeout Event Stream
  Stream<ZegoSignalingPluginOutgoingInvitationTimeoutEvent>
      getOutgoingInvitationTimeoutEventStream();
}
