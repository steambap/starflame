import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import "scifi_game.dart";
import 'cell.dart';
import 'action_type.dart';
import 'ship.dart';

abstract class Action {
  final Ship ship;
  final ActionType actionType;
  final ActionTarget targetType;
  final int cooldown;
  final IconData icon;

  Action(this.ship, this.actionType, this.targetType, this.icon,
      {this.cooldown = 0});

  int cooldownLeft() {
    if (cooldown == 0) {
      return 0;
    }

    return ship.getActionState(actionType)?.cooldown ?? 0;
  }

  void activate(ScifiGame game);
  bool isDisabled(ScifiGame game);
  Iterable<Cell> getTargetCells(ScifiGame game);
}

class Capture extends Action {
  Capture(Ship ship)
      : super(ship, ActionType.capture, ActionTarget.self, Symbols.flag_rounded);

  @override
  void activate(ScifiGame game) {
    ship.useAttack();
    final playerNumber = game.controller.getHumanPlayerNumber();
    game.resourceController.capture(playerNumber, game.mapGrid.cellAtHex(ship.hex)!);
    game.mapGrid.unSelect();
  }

  @override
  bool isDisabled(ScifiGame game) {
    final planet = game.mapGrid.cellAtHex(ship.hex)?.planet;
    if (planet == null) {
      return true;
    }
    if (planet.playerNumber == ship.state.playerNumber) {
      return true;
    }

    return !ship.canAttack();
  }

  @override
  Iterable<Cell> getTargetCells(ScifiGame game) {
    return const [];
  }
}

class Stay extends Action {
  Stay(Ship ship)
      : super(ship, ActionType.stay, ActionTarget.self, Symbols.check_rounded);

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
}
