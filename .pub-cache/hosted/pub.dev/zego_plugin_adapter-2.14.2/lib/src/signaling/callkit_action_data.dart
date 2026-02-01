/// CallKit Action 数据基类
/// 所有具体的 Action 数据类都应该继承此类
abstract class ZegoSignalingPluginCallKitActionData {
  /// 通话的唯一标识符
  final String callUUID;

  ZegoSignalingPluginCallKitActionData({required this.callUUID});
}

/// 开始通话 Action 数据
class ZegoSignalingPluginCallKitStartActionData
    extends ZegoSignalingPluginCallKitActionData {
  /// 远程用户的句柄
  final String handle;

  /// 联系人标识符
  final String contactIdentifier;

  /// 是否为视频通话
  final bool video;

  ZegoSignalingPluginCallKitStartActionData({
    required super.callUUID,
    required this.handle,
    required this.contactIdentifier,
    required this.video,
  });
}

/// 接听通话 Action 数据
class ZegoSignalingPluginCallKitAnswerActionData
    extends ZegoSignalingPluginCallKitActionData {
  ZegoSignalingPluginCallKitAnswerActionData({required super.callUUID});
}

/// 结束通话 Action 数据
class ZegoSignalingPluginCallKitEndActionData
    extends ZegoSignalingPluginCallKitActionData {
  ZegoSignalingPluginCallKitEndActionData({required super.callUUID});
}

/// 设置通话保持状态 Action 数据
class ZegoSignalingPluginCallKitSetHeldActionData
    extends ZegoSignalingPluginCallKitActionData {
  /// 是否保持通话
  final bool onHold;

  ZegoSignalingPluginCallKitSetHeldActionData({
    required super.callUUID,
    required this.onHold,
  });
}

/// 设置静音状态 Action 数据
class ZegoSignalingPluginCallKitSetMutedActionData
    extends ZegoSignalingPluginCallKitActionData {
  /// 是否静音
  final bool muted;

  ZegoSignalingPluginCallKitSetMutedActionData({
    required super.callUUID,
    required this.muted,
  });
}

/// 设置群组通话 Action 数据
class ZegoSignalingPluginCallKitSetGroupActionData
    extends ZegoSignalingPluginCallKitActionData {
  ZegoSignalingPluginCallKitSetGroupActionData({required super.callUUID});
}

/// 播放 DTMF 音调 Action 数据
class ZegoSignalingPluginCallKitPlayDTMFActionData
    extends ZegoSignalingPluginCallKitActionData {
  /// DTMF 数字
  final String digits;

  /// DTMF 类型
  final String type;

  ZegoSignalingPluginCallKitPlayDTMFActionData({
    required super.callUUID,
    required this.digits,
    required this.type,
  });
}

/// 超时执行 Action 数据
class ZegoSignalingPluginCallKitTimedOutActionData
    extends ZegoSignalingPluginCallKitActionData {
  ZegoSignalingPluginCallKitTimedOutActionData({required super.callUUID});
}
