import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:qs_getx_tool/qs_getx_tool.dart';

void main() {
  test('worker registered after disposal is stopped immediately', () {
    final disposeBag = QsDisposeBag()..dispose();
    final value = 0.obs;
    var callbackCount = 0;
    QsGetxTool.ever<int>(
      value,
      disposeBag: disposeBag,
      callback: (_) => callbackCount++,
    );

    value.value = 1;

    expect(callbackCount, 0);
  });

  test('ever worker stops after disposal', () {
    final disposeBag = QsDisposeBag();
    final value = 0.obs;
    var callbackCount = 0;
    QsGetxTool.ever<int>(
      value,
      disposeBag: disposeBag,
      callback: (_) => callbackCount++,
    );

    value.value = 1;
    disposeBag.dispose();
    value.value = 2;

    expect(callbackCount, 1);
  });

  test('everAll worker stops after disposal', () {
    final disposeBag = QsDisposeBag();
    final firstValue = 0.obs;
    final secondValue = 0.obs;
    var callbackCount = 0;
    QsGetxTool.everAll(
      [firstValue, secondValue],
      disposeBag: disposeBag,
      callback: (_) => callbackCount++,
    );

    firstValue.value = 1;
    secondValue.value = 1;
    disposeBag.dispose();
    firstValue.value = 2;

    expect(callbackCount, 2);
  });

  test('debounce worker stops after disposal', () {
    fakeAsync((async) {
      final disposeBag = QsDisposeBag();
      final value = 0.obs;
      var callbackCount = 0;
      QsGetxTool.debounce<int>(
        value,
        time: const Duration(milliseconds: 10),
        disposeBag: disposeBag,
        callback: (_) => callbackCount++,
      );

      value.value = 1;
      disposeBag.dispose();
      async.elapse(const Duration(milliseconds: 20));

      expect(callbackCount, 0);
    });
  });
}
