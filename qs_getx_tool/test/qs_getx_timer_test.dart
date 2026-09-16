import 'dart:async';

import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qs_getx_tool/qs_getx_tool.dart';

void main() {
  group('QsGetxTimer.period', () {
    for (final dueTime in <Duration>[
      const Duration(milliseconds: 5),
      const Duration(milliseconds: 10),
      const Duration(milliseconds: 15),
    ]) {
      test('starts periodically after a ${dueTime.inMilliseconds}ms delay', () {
        fakeAsync((async) {
          final disposeBag = QsDisposeBag();
          var callbackCount = 0;

          QsGetxTimer.period(
            dueTime: dueTime,
            duration: const Duration(milliseconds: 10),
            disposeBag: disposeBag,
            callback: (_) => callbackCount++,
          );

          async.elapse(dueTime);
          async.flushMicrotasks();
          expect(callbackCount, 0);

          async.elapse(const Duration(milliseconds: 10));
          expect(callbackCount, 1);
          disposeBag.dispose();
        });
      });
    }

    test('does not invoke callbacks when disposed during the delay', () {
      fakeAsync((async) {
        final disposeBag = QsDisposeBag();
        Timer? createdTimer;
        var callbackCount = 0;

        QsGetxTimer.period(
          dueTime: const Duration(milliseconds: 10),
          duration: const Duration(milliseconds: 5),
          disposeBag: disposeBag,
          callback: (_) => callbackCount++,
        ).then((timer) => createdTimer = timer);

        async.elapse(const Duration(milliseconds: 5));
        disposeBag.dispose();
        async.elapse(const Duration(milliseconds: 5));
        async.flushMicrotasks();
        async.elapse(const Duration(milliseconds: 20));

        expect(createdTimer, isNotNull);
        expect(createdTimer!.isActive, isFalse);
        expect(callbackCount, 0);
      });
    });
  });
}
