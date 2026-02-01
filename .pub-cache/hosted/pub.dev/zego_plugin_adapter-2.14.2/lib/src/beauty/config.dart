import 'package:zego_plugin_adapter/src/beauty/enums.dart';
import 'package:zego_plugin_adapter/src/beauty/inner_text.dart';
import 'package:zego_plugin_adapter/src/beauty/ui_config.dart';

/// config of beauty plugin
class ZegoBeautyPluginConfig {
  late List<ZegoBeautyPluginEffectsType> effectsTypes;

  late ZegoBeautyPluginInnerText innerText;

  late ZegoBeautyPluginUIConfig uiConfig;

  // backgroundPortraitSegmentation feature need use this path.
  String? segmentationBackgroundImageName;

  // if true, can use getFaceDetection to notify face detection.
  bool enableFaceDetection = false;

  /// for how to obtain the license file and the implementation steps of online
  /// authentication, you can refer to this [https://docs.zegocloud.com/article/12291].
  String Function()? license;

  ZegoBeautyPluginSegmentationScaleMode segmentationScaleMode =
      ZegoBeautyPluginSegmentationScaleMode.aspectFill;

  ZegoBeautyPluginConfig({
    List<ZegoBeautyPluginEffectsType>? effectsTypes,
    ZegoBeautyPluginInnerText? innerText,
    ZegoBeautyPluginUIConfig? uiConfig,
    this.segmentationBackgroundImageName,
    this.segmentationScaleMode =
        ZegoBeautyPluginSegmentationScaleMode.aspectFill,
    this.enableFaceDetection = false,
    this.license,
  }) {
    this.effectsTypes = effectsTypes ?? allEffectsTypes();
    this.innerText = innerText ?? ZegoBeautyPluginInnerText();
    this.uiConfig = uiConfig ?? ZegoBeautyPluginUIConfig();
  }

  // default effects types.
  // https://www.zegocloud.com/pricing/product-list#ai-effects

  /// beautify Effects Types
  static List<ZegoBeautyPluginEffectsType> beautifyEffectsTypes({
    bool enableBasic = true,
    bool enableAdvanced = true,
    bool enableMakeup = true,
    bool enableStyle = true,
  }) {
    var types = <ZegoBeautyPluginEffectsType>[];
    if (enableBasic) {
      types += ZegoBeautyPluginEffectsType.values.sublist(
          ZegoBeautyPluginEffectsType.beautyBasicSmoothing.index,
          ZegoBeautyPluginEffectsType.beautyBasicDarkCircles.index + 1);
    }

    if (enableAdvanced) {
      types += ZegoBeautyPluginEffectsType.values.sublist(
          ZegoBeautyPluginEffectsType.beautyAdvancedFaceSlimming.index,
          ZegoBeautyPluginEffectsType.beautyAdvancedForeheadSlimming.index + 1);
    }

    if (enableMakeup) {
      types += ZegoBeautyPluginEffectsType.values.sublist(
          ZegoBeautyPluginEffectsType.beautyMakeupLipstickCameoPink.index,
          ZegoBeautyPluginEffectsType
                  .beautyMakeupColoredContactsChocolateBrown.index +
              1);
    }

    if (enableStyle) {
      types += ZegoBeautyPluginEffectsType.values.sublist(
          ZegoBeautyPluginEffectsType.beautyStyleMakeupInnocentEyes.index,
          ZegoBeautyPluginEffectsType.beautyStyleMakeupFlawless.index + 1);
    }

    return types;
  }

  /// filter Effects Types
  static List<ZegoBeautyPluginEffectsType> filterEffectsTypes() =>
      ZegoBeautyPluginEffectsType.values.sublist(
          ZegoBeautyPluginEffectsType.filterNaturalCreamy.index,
          ZegoBeautyPluginEffectsType.filterDreamySweet.index + 1);

  /// background Effects Types
  static List<ZegoBeautyPluginEffectsType> backgroundEffectsTypes() =>
      ZegoBeautyPluginEffectsType.values.sublist(
          ZegoBeautyPluginEffectsType.backgroundGreenScreenSegmentation.index,
          ZegoBeautyPluginEffectsType.backgroundGaussianBlur.index + 1);

  /// all Effects Types
  static List<ZegoBeautyPluginEffectsType> allEffectsTypes() {
    return List.from(ZegoBeautyPluginEffectsType.values)
      ..remove(ZegoBeautyPluginEffectsType.backgroundGreenScreenSegmentation);
  }
}
