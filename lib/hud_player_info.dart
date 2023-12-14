import 'dart:async';

import 'package:flame/components.dart';

import 'scifi_game.dart';

class HudPlayerInfo extends PositionComponent with HasGameRef<ScifiGame> {
  final TextComponent _energyLabel = TextComponent();
  HudPlayerInfo();

  @override
  FutureOr<void> onLoad() {
    position = Vector2(8, 8);

    add(_energyLabel);
  }

  updateRender() {
    final playerState = game.gameStateController.getHumanPlayerState();
    final t = game.gameStateController.gameState.turn;
    _energyLabel.text = "\$${playerState.energy}(0) turn $t";
  }
}
