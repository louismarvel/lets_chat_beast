import 'dart:core';

import 'package:flutter/material.dart';

import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';

/// @nodoc
abstract class ZegoBeautyPluginInterface with IZegoUIKitPlugin {
  /// init
  void init({
    required int appID,
    required String appSign,
  });

  /// uninit
  void uninit();

  /// set Config
  void setConfig(ZegoBeautyPluginConfig config);

  /// show Beauty UI
  void showBeautyUI(BuildContext context);

  /// Set default beauty parameters
  Future<void> setBeautyParams(List<ZegoBeautyParamConfig> paramConfigList,
      {bool forceUpdateCache = false});

  /// get Face Detection Event Stream
  Stream<ZegoBeautyPluginFaceDetectionData> getFaceDetectionEventStream();

  /// get Error Stream
  Stream<ZegoBeautyError> getErrorStream();
}
