import 'dart:async';

import 'package:get/get.dart' as getx;
import 'package:qs_getx_tool/qs_dispose_bag.dart';

export 'qs_dispose_bag.dart';
export 'qs_dispose_controller.dart';
export 'qs_getx_timer.dart';

class QsGetxTool {
  /// 监听
  static void ever<T>(
    getx.RxInterface<T> listener, {
    dynamic condition = true,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
    required QsDisposeBag disposeBag,
    required getx.WorkerCallback<T> callback,
  }) {
    final worker = getx.ever(
      listener,
      condition: condition,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
      callback,
    );
    disposeBag.addWorker(worker);
  }

  /// 监听所有
  static void everAll(
    List<getx.RxInterface> listeners, {
    dynamic condition = true,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
    required QsDisposeBag disposeBag,
    required getx.WorkerCallback callback,
  }) {
    final worker = getx.everAll(
      listeners,
      condition: condition,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
      callback,
    );
    disposeBag.addWorker(worker);
  }

  /// 防反跳监听
  static void debounce<T>(
    getx.RxInterface<T> listener, {
    required Duration time,
    required QsDisposeBag disposeBag,
    required getx.WorkerCallback<T> callback,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    Timer? timer;
    late StreamSubscription<T> subscription;
    subscription = listener.listen(
      (event) {
        timer?.cancel();
        timer = Timer(time, () => callback(event));
      },
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );
    final worker = getx.Worker(() async {
      timer?.cancel();
      await subscription.cancel();
    }, '[qs_debounce]');
    disposeBag.addWorker(worker);
  }
}
