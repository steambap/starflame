import 'dart:async';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' show Colors;

import 'scifi_game.dart';

class HudNextTurnBtn extends PositionComponent
    with HasGameRef<ScifiGame>, TapCallbacks {
  static final buttonSize = Vector2(100, 32);
  static final buttonPaint = Paint()..color = Colors.blue;
  final RectangleComponent rect = RectangleComponent(
      size: buttonSize, paint: buttonPaint);
  final TextComponent buttonText = TextComponent(
      text: "Next Turn", anchor: Anchor.center, scale: Vector2.all(0.75));
  HudNextTurnBtn() : super(size: buttonSize);

  @override
  FutureOr<void> onLoad() {
    position = Vector2(game.size.x - buttonSize.x - 8,
        game.size.y - buttonSize.y - 8);

    buttonText.position = buttonSize / 2;

    addAll([rect, buttonText]);
  }

  @override
  void onTapUp(TapUpEvent event) {
    game.gameStateController.endTurn();
  }
}
