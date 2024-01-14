import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:starfury/select_control.dart';

import 'action.dart';
import 'action_type.dart';
import 'cell.dart';
import 'theme.dart';
import 'scifi_game.dart';

class ActionButton extends SpriteComponent
    with HasGameRef<ScifiGame>, TapCallbacks {
  final Action action;
  final Cell cell;

  ActionButton(this.cell, this.action) : super(size: Vector2.all(32));

  @override
  FutureOr<void> onLoad() {
    final img = game.images.fromCache("${action.actionType.name}.png");
    sprite = Sprite(img);
    scale = Vector2.all(0.75);

    if (!action.isEnabled(game.mapGrid, cell)) {
      decorator.addLast(grayTint);
    }
  }

  @override
  void onTapUp(TapUpEvent event) {
    if (action.isEnabled(game.mapGrid, cell)) {
      if (action.targetType == ActionTarget.self) {
        action.execute(cell.ship!, cell);
      } else {
        game.mapGrid.selectControl =
            SelectControlWaitForAction(action, cell, game);
      }
    }
  }
}
