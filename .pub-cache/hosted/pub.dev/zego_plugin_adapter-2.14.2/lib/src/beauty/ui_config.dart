import 'package:flutter/material.dart';

/// Zego Beauty Plugin UI Config
class ZegoBeautyPluginUIConfig {
  Color? backgroundColor;

  Color? selectedIconBorderColor;
  Color? selectedIconDotColor;

  TextStyle? selectedTextStyle;
  TextStyle? normalTextStyle;

  TextStyle? sliderTextStyle;
  Color? sliderTextBackgroundColor;
  Color? sliderActiveTrackColor;
  Color? sliderInactiveTrackColor;
  Color? sliderThumbColor;
  double? sliderThumbRadius;

  Widget? backIcon;

  TextStyle? normalHeaderTitleTextStyle;
  TextStyle? selectHeaderTitleTextStyle;

  ZegoBeautyPluginUIConfig({
    this.backgroundColor,
    this.selectedIconBorderColor,
    this.selectedIconDotColor,
    this.selectedTextStyle,
    this.normalTextStyle,
    this.sliderTextStyle,
    this.sliderActiveTrackColor,
    this.sliderInactiveTrackColor,
    this.sliderThumbColor,
    this.normalHeaderTitleTextStyle,
    this.selectHeaderTitleTextStyle,
  });
}
