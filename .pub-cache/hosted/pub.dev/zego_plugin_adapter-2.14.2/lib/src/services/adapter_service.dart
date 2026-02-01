import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'package:flutter_logs_yoer/flutter_logs_yoer.dart';

part 'system.dart';

part 'logger_service.dart';

/// @nodoc
class ZegoPluginAdapterService
    with ZegoSystemService, ZegoAdapterLoggerService {
  factory ZegoPluginAdapterService() => instance;

  ZegoPluginAdapterService._internal() {
    WidgetsFlutterBinding.ensureInitialized();
  }

  /// init
  void init() async {
    if (_init) {
      return;
    }

    _init = true;

    await initLog();
    initSystemService();
  }

  static final ZegoPluginAdapterService instance =
      ZegoPluginAdapterService._internal();

  bool _init = false;
}
