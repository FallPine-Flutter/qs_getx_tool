import 'package:flutter/foundation.dart';

class TrackedChangeNotifier extends ChangeNotifier {
  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  bool isDisposed = false;
}
