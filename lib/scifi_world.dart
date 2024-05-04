import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/effects.dart';
import "package:flutter/foundation.dart";
import 'package:flutter/services.dart';

import 'scifi_game.dart';
import 'menu_planet_cmd.dart';
import "planet.dart";
import "theme.dart" show textDamage;

class ScifiWorld extends World
    with HasGameRef<ScifiGame>, KeyboardHandler, DragCallbacks {
  final double moveSpeed = 64;
  Vector2 direction = Vector2.zero();
  MenuPlanetCmd? _menuPlanetCmd;

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

  void renderPlanetMenu(Planet? planet) {
    if (planet == null) {
      _menuPlanetCmd?.removeFromParent();
      return;
    }

    _menuPlanetCmd = MenuPlanetCmd(planet);
    _menuPlanetCmd!.position = planet.hex.toPixel();
    add(_menuPlanetCmd!);
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
}
