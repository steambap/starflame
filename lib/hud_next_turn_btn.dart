import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'scifi_game.dart';
import "theme.dart" show text16, buttonPaintLayer;

class HudNextTurnBtn extends PositionComponent
    with HasGameRef<ScifiGame>, TapCallbacks {
  static final buttonSize = Vector2(100, 32);
  final RectangleComponent rect =
      RectangleComponent(size: buttonSize, paintLayers: buttonPaintLayer);
  final TextComponent buttonText = TextComponent(
      text: "Next Turn", anchor: Anchor.center, textRenderer: text16);
  HudNextTurnBtn() : super(size: buttonSize);

  @override
  FutureOr<void> onLoad() {
    position =
        Vector2(game.size.x - buttonSize.x - 8, game.size.y - buttonSize.y - 8);

    buttonText.position = buttonSize / 2;

    addAll([rect, buttonText]);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.controller.endTurn();
  }
}
