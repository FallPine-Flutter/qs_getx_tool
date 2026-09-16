import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'support/test_dispose_controller.dart';

void main() {
  test('onClose disposes registered resources', () {
    final controller = TestDisposeController();
    final timer = Timer.periodic(const Duration(seconds: 1), (_) {});
    controller.disposeBag.addTimer(timer);

    controller.onClose();

    expect(timer.isActive, isFalse);
  });
}
