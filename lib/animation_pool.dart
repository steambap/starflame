import "dart:collection";
import "dart:async";

import "scifi_game.dart";
import "select_control.dart";
import "logger.dart";

typedef AnimationFuture = Future<void> Function();

class AnimationPool {
  final ScifiGame game;
  final Queue<AnimationFuture> _pool = Queue();
  bool _running = false;
  bool _paused = false;
  bool userSkip = false;

  AnimationPool(this.game);

  bool get running => _running;
  bool get paused => _paused;
  set paused(bool value) {
    if (_paused == value) {
      return;
    }

    _paused = value;
    if (!_paused) {
      _run();
    }
  }

  void add(AnimationFuture callback) {
    _pool.add(callback);
    _run();
  }

  void addSyncFunc(void Function() callback, [int? time]) {
    _pool.add(() async {
      callback();

      return Future.delayed(Duration(milliseconds: time ?? 0));
    });
    _run();
  }

  void addTimeout(int time) {
    _pool.add(() => Future.delayed(Duration(milliseconds: time)));
    _run();
  }

  void _run() async {
    if (!game.controller.isGameStarted || _running || _paused || _pool.isEmpty) {
      return;
    }

    _running = true;
    game.mapGrid.selectControl = SelectControlBlockInput(game);
    final item = _pool.removeFirst();
    if (userSkip) {
      _next();
      return;
    }
    
    try {
      await item();
    } catch (e) {
      logger.w("Animation error: $e");
    }

    _next();
  }

  void _next() {
    if (!game.controller.isAITurn() && game.mapGrid.selectControl is SelectControlBlockInput) {
      game.mapGrid.selectControl = SelectControlWaitForInput(game);
    }
    _running = false;
    _run();
  }
}
