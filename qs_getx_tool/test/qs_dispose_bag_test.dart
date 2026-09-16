import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qs_getx_tool/qs_getx_tool.dart';

import 'support/tracked_change_notifier.dart';

void main() {
  group('QsDisposeBag', () {
    test('removes registered listeners with the original callback', () {
      final disposeBag = QsDisposeBag();
      final notifier = ChangeNotifier();
      var callbackCount = 0;

      disposeBag.addListener(
        controller: notifier,
        listener: () => callbackCount++,
      );
      notifier.notifyListeners();
      disposeBag.dispose();
      notifier.notifyListeners();

      expect(callbackCount, 1);
    });

    test('disposes registered resources and is idempotent', () async {
      var subscriptionCancelCount = 0;
      final streamController = StreamController<void>(
        onCancel: () => subscriptionCancelCount++,
      );
      final subscription = streamController.stream.listen((_) {});
      final notifier = TrackedChangeNotifier();
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {});
      final disposeBag = QsDisposeBag()
        ..addStreamSubscription(subscription)
        ..addController(notifier)
        ..addTimer(timer);

      disposeBag.dispose();
      disposeBag.dispose();
      await Future<void>.delayed(Duration.zero);

      expect(subscriptionCancelCount, 1);
      expect(notifier.isDisposed, isTrue);
      expect(timer.isActive, isFalse);
      await streamController.close();
    });

    test('immediately releases resources added after disposal', () async {
      final disposeBag = QsDisposeBag()..dispose();
      final notifier = TrackedChangeNotifier();
      final timer = Timer.periodic(const Duration(seconds: 1), (_) {});
      var subscriptionCancelCount = 0;
      final streamController = StreamController<void>(
        onCancel: () => subscriptionCancelCount++,
      );
      final subscription = streamController.stream.listen((_) {});
      final listenerController = ChangeNotifier();
      var listenerCallCount = 0;

      disposeBag
        ..addController(notifier)
        ..addTimer(timer)
        ..addStreamSubscription(subscription)
        ..addListener(
          controller: listenerController,
          listener: () => listenerCallCount++,
        );
      listenerController.notifyListeners();
      await Future<void>.delayed(Duration.zero);

      expect(notifier.isDisposed, isTrue);
      expect(timer.isActive, isFalse);
      expect(subscriptionCancelCount, 1);
      expect(listenerCallCount, 0);
      await streamController.close();
    });
  });
}
