/// Background MessageT ype
enum BackgroundMessageType {
  invitation,
  cancelInvitation,
  textMessage,
  mediaMessage,
}

extension BackgroundMessageTypeExtension on BackgroundMessageType {
  String get text {
    switch (this) {
      case BackgroundMessageType.invitation:
        return 'invitation';
      case BackgroundMessageType.cancelInvitation:
        return 'cancel_invitation';
      case BackgroundMessageType.textMessage:
        return 'text_msg';
      case BackgroundMessageType.mediaMessage:
        return 'media_msg';
    }
  }

  static BackgroundMessageType fromText(String text) {
    if (BackgroundMessageType.cancelInvitation.text == text) {
      return BackgroundMessageType.cancelInvitation;
    } else if (BackgroundMessageType.textMessage.text == text) {
      return BackgroundMessageType.textMessage;
    } else if (BackgroundMessageType.mediaMessage.text == text) {
      return BackgroundMessageType.mediaMessage;
    }

    return BackgroundMessageType.invitation;
  }
}
