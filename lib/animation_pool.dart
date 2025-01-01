import "dart:collection";
import "dart:async";

import "scifi_game.dart";
import "animation_item.dart";
import "select_control.dart";

class AnimationPool {
  final ScifiGame game;
  final Queue<AnimationItem> _pool = Queue();
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

  void add(void Function() callback, [int? time]) {
    _pool.add(AnimationItem(callback, time));
    _run();
  }

  void addTimeout(int time) {
    _pool.add(AnimationItem(null, time));
  }

  void _run() {
    if (!game.controller.isGameStarted || _running || _paused || _pool.isEmpty) {
      return;
    }

    _running = true;
    game.mapGrid.selectControl = SelectControlBlockInput(game);
    final item = _pool.removeFirst();
    if (userSkip) {
      next();
      return;
    }
    if (item.time != null) {
      if (item.callback != null) {
        item.callback!();
      }
      Future.delayed(Duration(milliseconds: item.time!), next);
      return;
    }
    if (item.callback != null) {
      item.callback!();
    }
    next();
  }

  void next() {
    if (!game.controller.isAITurn() && game.mapGrid.selectControl is SelectControlBlockInput) {
      game.mapGrid.selectControl = SelectControlWaitForInput(game);
    }
    _running = false;
    _run();
  }
}
