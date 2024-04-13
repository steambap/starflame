import 'dart:async';
import 'package:flame/components.dart';

import 'scifi_game.dart';
import "theme.dart" show text16, buttonPaintLayer, buttonHoverPaintLayer;

class HudNextTurnBtn extends AdvancedButtonComponent
    with HasGameRef<ScifiGame> {
  static final buttonSize = Vector2(100, 32);
  HudNextTurnBtn()
      : super(
          size: buttonSize,
          defaultLabel: TextComponent(
              text: "Next Turn", anchor: Anchor.center, textRenderer: text16),
          defaultSkin: RectangleComponent(
              size: buttonSize, paintLayers: buttonPaintLayer),
          hoverSkin: RectangleComponent(
              size: buttonSize, paintLayers: buttonHoverPaintLayer),
        );

  @override
  Future<void> onLoad() {
    position =
        Vector2(game.size.x - buttonSize.x - 8, game.size.y - buttonSize.y - 8);
    onPressed = () {
      if (game.controller.isAITurn()) {
        return;
      }
      game.controller.endTurn(false);
    };

    return super.onLoad();
  }
}
