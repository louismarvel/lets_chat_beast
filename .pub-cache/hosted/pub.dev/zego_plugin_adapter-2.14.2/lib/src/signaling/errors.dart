/// signaling error
class ZegoSignalingError {
  int code;
  String message;
  String method;

  ZegoSignalingError({
    required this.code,
    required this.message,
    required this.method,
  });

  @override
  String toString() {
    return '{signaling error, code:$code, message:$message, method:$method}';
  }
}

/// uikit-${library_type}-${error_type}-${error_code}
/// 3-xx-xxx-xxx
///
/// library_type: {
///   00:uikit;
///
///   01:signaling plugin;
///   02:adapter plugin;
///   03:beauty plugin;
///
///   10:call prebuilt;
///   11:live audio room prebuilt;
///   12:live streaming prebuilt;
///   13:video conference prebuilt;
///   14:zim-kit;
/// }
///
/// --------------------------------
///
/// 3-01-xxx-xxx
///
/// error type: {
///   internal(001): 301001-xxx
///   callkit(002): 301002-xxx
///   invitation(003): 301003-xxx
///   message(004): 301004-xxx
///   notification(005): 301005-xxx
///   room(006): 301006-xxx
///   user(007): 301007-xxx
/// }
class ZegoSignalingErrorCode {
  /// Execution successful.
  static const int success = 0;

  ///
  static const int platformNotSupport = 301001001;

  ///
  static const int userNotLogin = 301001002;

  ///
  static const int userLoginError = 301001003;

  ///
  static const int roomNotLogin = 301001004;

  ///
  static const int roomLoginError = 301001005;

  ///
  static const int roomLogoutError = 301001006;

  ///
  static const int renewTokenError = 301001007;

  ///
  static const int roomPropertyUpdateError = 301001008;

  ///
  static const int roomPropertyDeleteError = 301001009;

  ///
  static const int roomPropertyEndBatchError = 301001010;

  ///
  static const int roomPropertyQueryError = 301001011;

  ///
  static const int userInRoomPropertyQueryError = 301001012;

  ///
  static const int userInRoomPropertySetError = 301001013;

  ///
  static const int callkitActiveAudioError = 301002001;

  ///
  static const int invitationSendError = 301003001;

  ///
  static const int invitationCancelError = 301003002;

  ///
  static const int invitationRefuseError = 301003003;

  ///
  static const int invitationAcceptError = 301003004;

  ///
  static const int invitationAddError = 301003005;

  ///
  static const int invitationQuitError = 301003006;

  ///
  static const int invitationEndError = 301003007;

  ///
  static const int invitationJoinError = 301003008;

  ///
  static const int inRoomTextMessageSendError = 301004001;

  ///
  static const int inRoomCommandMessageSendError = 301004002;

  ///
  static const int checkAppRunningError = 301005001;

  ///
  static const int notificationAddError = 301005002;

  ///
  static const int notificationCreateChannelError = 301005003;

  ///
  static const int notificationDismissError = 301005004;

  ///
  static const int activeAppToForegroundError = 301005005;

  ///
  static const int requestDismissKeyguardError = 301005006;

  ///
  static const int notificationEnableNotifyError = 301005007;

  static String zimErrorCodeDocumentTips =
      'please refer to the error codes document https://docs.zegocloud.com/article/13792 for details.';
}
