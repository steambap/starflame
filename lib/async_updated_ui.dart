import 'dart:async';

mixin AsyncUpdatedUi {
  bool _isScheduled = false;
  void updateRender();

  void scheduleUpdate() {
    if (_isScheduled) {
      return;
    }
    _isScheduled = true;

    Future.delayed(const Duration(milliseconds: 100), () {
      _isScheduled = false;
      updateRender();
    });
  }
}
