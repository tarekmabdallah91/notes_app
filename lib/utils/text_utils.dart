import 'package:flutter/foundation.dart';

class TextUtils {
  static printLog(String tag, Object data) {
    if (kDebugMode) {
      print('$tag : $data');
    }
  }
}
