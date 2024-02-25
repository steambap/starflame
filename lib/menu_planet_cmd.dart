import 'dart:async';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'planet.dart';
import 'theme.dart' show text12, textButtonPaintLayer, panelBackground;

class MenuPlanetCmd extends PositionComponent with HasGameRef<ScifiGame> {
  final Planet planet;
  final _background = RectangleComponent(
    size: Vector2(108, 32),
    paint: panelBackground,
  );
  final _colonyTypeButton = RectangleComponent(
    paintLayers: textButtonPaintLayer,
    size: Vector2(100, 24),
    position: Vector2(4, 4),
  );
  final _colonyTypeButtonText = TextComponent(
    text: "Colony Type",
    textRenderer: text12,
    position: Vector2(8, 16),
    anchor: Anchor.centerLeft,
  );

  MenuPlanetCmd(this.planet);

  @override
  FutureOr<void> onLoad() {
    addAll([
      _background,
      _colonyTypeButton,
      _colonyTypeButtonText,
    ]);
  }
}
