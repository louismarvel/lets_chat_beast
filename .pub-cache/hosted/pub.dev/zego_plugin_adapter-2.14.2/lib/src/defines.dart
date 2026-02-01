/// plugin type
enum ZegoUIKitPluginType {
  signaling, // zim, fcm
  beauty, // effects or avatar
  whiteboard, // superboard
  callkit,
}

/// plugin interface
mixin IZegoUIKitPlugin {
  /// getPluginType
  ZegoUIKitPluginType getPluginType();

  /// getVersion
  Future<String> getVersion();

  Future<void> setAdvancedConfig(String key, String value);

  @override
  String toString() {
    return 'IZegoUIKitPlugin:{'
        'type:${getPluginType()}, '
        'version:${getVersion()}, '
        '}';
  }
}
