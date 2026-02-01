library;

import 'package:flutter/material.dart';

import 'package:zego_plugin_adapter/src/adapter.dart';
import 'package:zego_plugin_adapter/src/services/adapter_service.dart';

export 'src/adapter.dart';
export 'src/services/adapter_service.dart';
export 'src/signaling/defines.dart';
export 'src/signaling/callkit_action_data.dart';
export 'src/signaling/callkit_defines.dart';

/// @nodoc
class ZegoPluginAdapter {
  factory ZegoPluginAdapter() => instance;

  ZegoPluginAdapter._internal() {
    WidgetsFlutterBinding.ensureInitialized();
    _impl = ZegoPluginAdapterImpl();

    ZegoPluginAdapterService.instance.init();
  }

  late final ZegoPluginAdapterImpl _impl;
  static final ZegoPluginAdapter instance = ZegoPluginAdapter._internal();

  /// version
  String getVersion() {
    return _impl.getVersion();
  }

  /// if you want to receive notifications for plugin installation, you can listen to this.
  ValueNotifier<List<ZegoUIKitPluginType>> get pluginsInstallNotifier =>
      _impl.pluginsInstallNotifier;

  /// install specified plugins
  void installPlugins(List<IZegoUIKitPlugin> instances) {
    _impl.installPlugins(instances);
  }

  /// uninstall specified plugins
  void uninstallPlugins(List<IZegoUIKitPlugin> instances) {
    _impl.uninstallPlugins(instances);
  }

  /// get install of specified plugin
  IZegoUIKitPlugin? getPlugin(ZegoUIKitPluginType type) {
    return _impl.getPlugin(type);
  }

  ZegoPluginAdapterService service() {
    return ZegoPluginAdapterService.instance;
  }

  /// signaling plugin instance
  ZegoSignalingPluginInterface? get signalingPlugin => _impl.signalingPlugin;

  /// callkit plugin instance
  ZegoCallKitInterface? get callkit => _impl.callkit;

  /// beauty plugin instance
  ZegoBeautyPluginInterface? get beautyPlugin => _impl.beautyPlugin;
}
