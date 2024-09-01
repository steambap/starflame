import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import "package:flutter/foundation.dart";
import 'package:flutter/services.dart';

import 'scifi_game.dart';
import "styles.dart" show textDamage;
import "ai/ai_log_overlay.dart";
import "ship.dart";

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
    if (keysPressed.contains(LogicalKeyboardKey.keyF)) {
      game.mapGrid.removeFog();
    }
    if (keysPressed.contains(LogicalKeyboardKey.enter)) {
      game.controller.playerEndTurn();
    }
    if (keysPressed.contains(LogicalKeyboardKey.keyC)) {
      game.router.pushRoute(AiLogOverlay());
    }
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

  void renderDamageText(String text, Vector2 position) {
    final textComponent =
        TextComponent(text: text, textRenderer: textDamage, position: position);

    final removeEff = RemoveEffect(delay: 0.5);
    final moveEff = MoveByEffect(
      Vector2(0, -18),
      EffectController(duration: 0.5),
    );
    textComponent.addAll([removeEff, moveEff]);
    add(textComponent);
  }

  void focusShip(Ship ship) {
    game.camera.moveTo(ship.cell.position);
  }
}
