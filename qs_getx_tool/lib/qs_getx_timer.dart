import 'dart:async';

import 'package:qs_getx_tool/qs_dispose_bag.dart';

class QsGetxTimer {
  static Future<Timer> period({
    Duration? dueTime,
    required Duration duration,
    required QsDisposeBag disposeBag,
    required void Function(Timer? timer) callback,
  }) async {
    if (dueTime != null) {
      await Future.delayed(dueTime);
    }
    final timer = Timer.periodic(duration, callback);
    disposeBag.addTimer(timer);
    return timer;
  }
}
