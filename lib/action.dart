import 'package:flame/components.dart';

import "scifi_game.dart";
import 'cell.dart';
import 'action_type.dart';
import 'ship.dart';
import "styles.dart" show icon16pale;

abstract class Action {
  final Ship ship;
  final ActionType actionType;
  final ActionTarget targetType;
  final int cooldown;

  Action(this.ship, this.actionType, this.targetType, {this.cooldown = 0});

  int cooldownLeft() {
    if (cooldown == 0) {
      return 0;
    }

    return ship.getActionState(actionType)?.cooldown ?? 0;
  }

  void activate(ScifiGame game);
  bool isDisabled(ScifiGame game);
  Iterable<Cell> getTargetCells(ScifiGame game);
  PositionComponent getLabel(ScifiGame game);
}

class Capture extends Action {
  Capture(Ship ship) : super(ship, ActionType.capture, ActionTarget.self);

  @override
  void activate(ScifiGame game) {
    ship.useAttack();
    final playerNumber = game.controller.getHumanPlayerNumber();
    game.resourceController.capture(playerNumber, ship.cell);
    game.mapGrid.unSelect();
  }

  @override
  bool isDisabled(ScifiGame game) {
    final sector = ship.cell.sector;
    if (sector == null) {
      return true;
    }
    if (sector.playerNumber == ship.state.playerNumber) {
      return true;
    }

    return !ship.canAttack();
  }

  @override
  Iterable<Cell> getTargetCells(ScifiGame game) {
    return const [];
  }

  @override
  PositionComponent getLabel(ScifiGame game) {
    return TextComponent(
      text: "\ue52d",
      textRenderer: icon16pale,
    );
  }
}

class Stay extends Action {
  Stay(Ship ship) : super(ship, ActionType.stay, ActionTarget.self);

  @override
  bool isDisabled(ScifiGame game) {
    return ship.movePoint() <= 0;
  }

  @override
  Iterable<Cell> getTargetCells(ScifiGame game) {
    return const [];
  }

  @override
  void activate(ScifiGame game) {
    ship.setTurnOver();
    game.mapGrid.unSelect();
  }

  @override
  PositionComponent getLabel(ScifiGame game) {
    return TextComponent(
      text: "\ue070",
      textRenderer: icon16pale,
    );
  }
}
