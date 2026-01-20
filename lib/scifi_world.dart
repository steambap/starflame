import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import "package:flutter/foundation.dart";
import 'package:flutter/services.dart';

import 'scifi_game.dart';
import "styles.dart";
import "hex.dart";

class ScifiWorld extends World
    with HasGameReference<ScifiGame>, KeyboardHandler, DragCallbacks {
  final double moveSpeed = 64;
  Vector2 direction = Vector2.zero();
  bool isGameStarted = false;

  @mustCallSuper
  @override
  void update(double dt) {
    final Vector2 velocity = direction * moveSpeed;

    game.camera.moveBy(velocity);
    super.update(dt);
  }

  @override
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    if (!isGameStarted) {
      return false;
    }

    // if (keysPressed
    //     .containsAll([LogicalKeyboardKey.shiftLeft, LogicalKeyboardKey.keyV])) {
    //   game.controller.debugWinGame();
    // }
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

  void renderBullet(PositionComponent from, PositionComponent to,
      void Function()? onComplete) {
    final bullet = SpriteComponent.fromImage(
      game.images.fromCache("ships/bullet.png"),
      anchor: Anchor.center,
      scale: Vector2.all(0.5),
    );
    bullet.position = from.position.clone();
    bullet.lookAt(to.position);

    final removeEff = RemoveEffect(delay: 0.1, onComplete: onComplete);
    final moveEff = MoveToEffect(
      to.position,
      EffectController(duration: 0.1),
    );
    bullet.addAll([removeEff, moveEff]);
    add(bullet);
  }

  void renderDamageText(String text, Vector2 position) {
    final textComponent = TextComponent(
        text: text, textRenderer: FlameTheme.textDamage, position: position);

    final removeEff = RemoveEffect(delay: 0.5);
    final moveEff = MoveByEffect(
      Vector2(0, -18),
      EffectController(duration: 0.5),
    );
    textComponent.addAll([removeEff, moveEff]);
    add(textComponent);
  }

  void startGame() {
    isGameStarted = true;
    final playerIdx = game.g.humanPlayerIdx;
    Hex hex = Hex.zero;
    for (final p in game.g.planets) {
      if (p.playerIdx == playerIdx && p.isHome()) {
        hex = p.hex;
        break;
      }
    }
    
    game.camera.moveTo(hex.toPixel());
  }
}
