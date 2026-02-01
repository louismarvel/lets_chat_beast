@JS('ZIM')
library zim_web;

import 'package:js/js.dart';

@JS()
class ZIM  {
  external static ZIM? create(dynamic appConfig);
  external static ZIM? getInstance();
  external static String getVersion();
}
