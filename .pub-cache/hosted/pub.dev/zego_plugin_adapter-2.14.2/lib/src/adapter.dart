import 'package:flutter/foundation.dart';

import 'package:zego_plugin_adapter/src/adapter.dart';
import 'package:zego_plugin_adapter/src/services/adapter_service.dart';

export 'beauty/beauty.dart';
export 'callkit/callkit.dart';
export 'defines.dart';
export 'signaling/signaling.dart';

/// @nodoc
class ZegoPluginAdapterImpl {
  /// plugin installed notify
  final pluginsInstallNotifier = ValueNotifier<List<ZegoUIKitPluginType>>([]);

  /// plugin instance map
  Map<ZegoUIKitPluginType, IZegoUIKitPlugin?> plugins = {
    for (var type in ZegoUIKitPluginType.values) type: null
  };

  /// version
  String getVersion() => 'zego_plugin_adapter: 2.14.2';

  /// install target plugins
  void installPlugins(List<IZegoUIKitPlugin> instances) {
    for (final item in instances) {
      final itemType = item.getPluginType();
      if (plugins[itemType] != null) {
        ZegoAdapterLoggerService.logInfo(
          'plugin type:$itemType already exists(${plugins[itemType].hashCode}), '
          'will update plugin instance ${item.hashCode}',
          tag: 'adapter',
          subTag: 'install plugins',
        );
      }

      plugins[itemType] = item;

      ZegoAdapterLoggerService.logInfo(
        'plugin type:$itemType install (${plugins[itemType].hashCode})',
        tag: 'adapter',
        subTag: 'install plugins',
      );
    }

    pluginsInstallNotifier.value = plugins.keys.toList();
  }

  /// uninstall target plugins
  void uninstallPlugins(List<IZegoUIKitPlugin> instances) {
    for (final item in instances) {
      final itemType = item.getPluginType();
      if (plugins[itemType] != null) {
        plugins.removeWhere((pluginType, plugin) {
          return itemType == pluginType;
        });

        ZegoAdapterLoggerService.logInfo(
          'plugin type:$itemType uninstalled',
          tag: 'adapter',
          subTag: 'uninstall plugins',
        );
      } else {
        ZegoAdapterLoggerService.logInfo(
          'plugin type:$itemType is not exists',
          tag: 'adapter',
          subTag: 'uninstall plugins',
        );
      }
    }

    pluginsInstallNotifier.value = plugins.keys.toList();
  }

  /// signaling plugin instance
  ZegoSignalingPluginInterface? get signalingPlugin {
    final ret = plugins[ZegoUIKitPluginType.signaling];
    if (ret == null) {
      ZegoAdapterLoggerService.logInfo(
        'signalingPlugin is null',
        tag: 'adapter',
        subTag: 'get plugin',
      );
      return null;
    }
    return ret as ZegoSignalingPluginInterface;
  }

  /// callkit plugin instance
  ZegoCallKitInterface? get callkit {
    final ret = plugins[ZegoUIKitPluginType.callkit];
    if (ret == null) {
      ZegoAdapterLoggerService.logInfo(
        'callkit is null',
        tag: 'adapter',
        subTag: 'get plugin',
      );
      return null;
    }
    return ret as ZegoCallKitInterface;
  }

  /// beauty plugin instance
  ZegoBeautyPluginInterface? get beautyPlugin {
    final ret = plugins[ZegoUIKitPluginType.beauty];
    if (ret == null) {
      ZegoAdapterLoggerService.logInfo(
        'beautyPlugin is null',
        tag: 'adapter',
        subTag: 'get plugin',
      );
      return null;
    }
    return ret as ZegoBeautyPluginInterface;
  }

  /// get specified plugin instance
  IZegoUIKitPlugin? getPlugin(ZegoUIKitPluginType type) {
    ZegoAdapterLoggerService.logInfo(
      'target:$type, current plugins:$plugins',
      tag: 'adapter',
      subTag: 'get plugin',
    );

    return plugins[type];
  }
}
