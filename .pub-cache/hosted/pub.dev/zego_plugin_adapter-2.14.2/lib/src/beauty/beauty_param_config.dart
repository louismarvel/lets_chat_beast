import 'package:zego_plugin_adapter/zego_plugin_adapter.dart';

class ZegoBeautyParamConfig {
  ZegoBeautyPluginEffectsType type;
  int value = 0;
  bool isSelected;

  ZegoBeautyParamConfig(this.type, this.isSelected, {this.value = 0});
}
