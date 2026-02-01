import 'dart:math';

import 'package:flutter/services.dart';

class ZegoBeautyPluginFaceDetectionData {
  /// Confidence Level of the detection result, where a higher value indicates a greater likelihood of being a human face.
  double score;

  /// The coordinates of the top-left corner of the rectangle that encloses the entire face.
  Point point;

  /// Size of the rectangle that encloses the entire face.
  Size size;

  ZegoBeautyPluginFaceDetectionData(this.score, this.point, this.size);

  @override
  String toString() {
    return '{beauty face detection data, '
        'score:$score, '
        'point:$point, '
        'size:$size}';
  }
}
