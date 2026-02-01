@JS('ZPNs')
library zpns_web;

import 'package:js/js.dart';

@JS()
class ZPNs {
  external static ZPNs? getInstance();
  external static String getVersion();
  external void register(dynamic config, dynamic zim);
  external void unregister();
}

