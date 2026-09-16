import 'package:get/get.dart';
import 'package:qs_getx_tool/qs_dispose_bag.dart';

abstract class QsDisposeController extends GetxController
    with QsDisposeBagMixin {
  /// System
  @override
  void onClose() {
    disposeDisposeBag();
    super.onClose();
  }
}
