import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QsDisposeBag {
  /// System
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    for (final worker in _everWorkers) {
      worker.dispose();
    }
    _everWorkers.clear();

    for (final subscription in _streamSubscriptions) {
      subscription.cancel().ignore();
    }
    _streamSubscriptions.clear();

    for (final listenerEntry in _listeners) {
      listenerEntry.controller.removeListener(listenerEntry.listener);
    }
    _listeners.clear();

    for (final controller in _controllers) {
      controller.dispose();
    }
    _controllers.clear();

    for (final timer in _timers) {
      timer.cancel();
    }
    _timers.clear();
  }

  /// Func
  void addWorker(Worker worker) {
    if (_isDisposed) {
      worker.dispose();
      return;
    }
    _everWorkers.add(worker);
  }

  void addStreamSubscription(StreamSubscription streamSubscription) {
    if (_isDisposed) {
      streamSubscription.cancel().ignore();
      return;
    }
    _streamSubscriptions.add(streamSubscription);
  }

  void addController(ChangeNotifier controller) {
    if (_isDisposed) {
      controller.dispose();
      return;
    }
    _controllers.add(controller);
  }

  void addListener({
    required ChangeNotifier controller,
    required VoidCallback listener,
  }) {
    if (_isDisposed) return;
    controller.addListener(listener);
    _listeners.add((controller: controller, listener: listener));
  }

  void addTimer(Timer timer) {
    if (_isDisposed) {
      timer.cancel();
      return;
    }
    _timers.add(timer);
  }

  /// Property
  final List<Worker> _everWorkers = [];
  final List<StreamSubscription> _streamSubscriptions = [];
  final List<ChangeNotifier> _controllers = [];
  final List<({ChangeNotifier controller, VoidCallback listener})> _listeners =
      [];
  final List<Timer> _timers = [];
  bool _isDisposed = false;
}

mixin QsDisposeBagMixin {
  final QsDisposeBag disposeBag = QsDisposeBag();

  void disposeDisposeBag() {
    disposeBag.dispose();
  }
}
