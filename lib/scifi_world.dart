import 'package:flame/components.dart';
import 'package:flame/events.dart';
import "package:flutter/foundation.dart";
import 'package:flutter/services.dart';

import 'scifi_game.dart';

class ScifiWorld extends World
    with HasGameRef<ScifiGame>, KeyboardHandler, DragCallbacks {
  final double moveSpeed = 64;
  Vector2 direction = Vector2.zero();

  @mustCallSuper
  @override
  void update(double dt) {
    final Vector2 velocity = direction * moveSpeed;

    game.camera.moveBy(velocity);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    direction = Vector2.zero();
    direction.x += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    direction.x += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    direction.y += (keysPressed.contains(LogicalKeyboardKey.keyW) ||
            keysPressed.contains(LogicalKeyboardKey.arrowUp))
        ? -1
        : 0;
    direction.y += (keysPressed.contains(LogicalKeyboardKey.keyS) ||
            keysPressed.contains(LogicalKeyboardKey.arrowDown))
        ? 1
        : 0;

    return true;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    game.camera.moveBy(-event.localDelta);
  }
}
