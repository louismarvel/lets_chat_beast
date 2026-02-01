enum ZegoSignalingPluginConnectionState {
  disconnected,
  connecting,
  connected,
  reconnecting,
}

enum ZegoSignalingPluginRoomState {
  disconnected,
  connecting,
  connected,
}

enum ZegoSignalingPluginConnectionAction {
  unknown,
  success,
  activeLogin,
  loginTimeout,
  interrupted,
  kickedOut,
  tokenExpired,
  unregistered
}

enum ZegoSignalingPluginRoomAction {
  success,
  interrupted,
  disconnected,
  roomNotExist,
  activeCreate,
  createFailed,
  activeEnter,
  enterFailed,
  kickedOut,
  connectTimeout,
  kickedOutByOtherDevice,
  activeSwitch,
  switchFailed
}

enum ZegoSignalingPluginCallUserState {
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

enum ZegoSignalingPluginMultiCertificate {
  firstCertificate,
  secondCertificate,
}

extension ZegoSignalingPluginIOSMultiCertificateExtension
    on ZegoSignalingPluginMultiCertificate {
  static ZegoSignalingPluginMultiCertificate fromID(int id) {
    switch (id) {
      case 0:
      case 1:
        return ZegoSignalingPluginMultiCertificate.firstCertificate;
      case 2:
        return ZegoSignalingPluginMultiCertificate.secondCertificate;
    }
    assert(false);
    return ZegoSignalingPluginMultiCertificate.firstCertificate;
  }

  int get id {
    switch (this) {
      case ZegoSignalingPluginMultiCertificate.firstCertificate:
        return 1;
      case ZegoSignalingPluginMultiCertificate.secondCertificate:
        return 2;
    }
  }
}
