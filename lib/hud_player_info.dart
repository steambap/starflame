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
    updateEnergy(100, 0);
  }

  updateEnergy(int current, int income) {
    _energyLabel.text = "\$$current($income)";
  }
}
