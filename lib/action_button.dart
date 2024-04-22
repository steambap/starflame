import 'dart:async';

import 'package:flame/components.dart';
import 'package:starfury/select_control.dart';

import 'action.dart';
import 'action_type.dart';
import 'cell.dart';
import 'theme.dart'
    show iconButtonSize, textButtonPaintLayer, textButtonDisabledPaintLayer;
import 'scifi_game.dart';

class ActionButton extends AdvancedButtonComponent with HasGameRef<ScifiGame> {
  final Action action;
  final Cell cell;

  ActionButton(this.cell, this.action) : super(size: iconButtonSize);

  @override
  Future<void> onLoad() async {
    isDisabled = action.isDisabled(game.mapGrid, cell);
    onPressed = () {
      if (action.targetType == ActionTarget.self) {
        action.execute(cell.ship!, cell);
        game.mapGrid.unSelect();
      } else {
        game.mapGrid.selectControl =
            SelectControlWaitForAction(action, cell, game);
      }
    };
    final img = game.images.fromCache("action_${action.actionType.name}.png");
    final sprite = Sprite(img);
    defaultSkin = RectangleComponent(
      size: iconButtonSize,
      paintLayers: textButtonPaintLayer,
      children: [
        SpriteComponent(
            anchor: Anchor.center,
            sprite: sprite,
            position: iconButtonSize / 2),
      ],
    );
    disabledSkin = RectangleComponent(
      size: iconButtonSize,
      paintLayers: textButtonDisabledPaintLayer,
      children: [
        SpriteComponent(
            anchor: Anchor.center,
            sprite: sprite,
            position: iconButtonSize / 2),
      ],
    );

    super.onLoad();
  }
}
