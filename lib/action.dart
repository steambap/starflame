import 'package:flame/components.dart';

import 'cell.dart';
import 'action_type.dart';
import 'map_grid.dart';
import 'ship.dart';

sealed class Action {
  final ActionType actionType;
  final ActionTarget targetType;
  final bool requireAttack;
  final int cooldown;
  final Block range;

  Action(
    this.actionType,
    this.targetType, {
    this.requireAttack = false,
    this.cooldown = 0,
    this.range = const Block(0, 0),
  });

  int cooldownLeft(Cell cell) {
    if (cooldown == 0) {
      return 0;
    }

    final state = cell.ship?.getActionState(actionType);
    return state?.cooldown ?? 0;
  }

  bool isDisabled(MapGrid mapGrid, Cell cell) {
    if (cooldownLeft(cell) > 0) {
      return true;
    }

    if (requireAttack) {
      if (!(cell.ship?.canAttack() ?? false)) {
        return true;
      }
    }
    return getTargets(mapGrid, cell).isEmpty;
  }

  List<Cell> neutralPlanetCells(List<Cell> cells) {
    return cells.where((cell) => cell.planet?.neutral() ?? false).toList();
  }

  List<Cell> enemyPlanetCells(List<Cell> cells, int playerNumber) {
    return cells
        .where((cell) => cell.planet?.attackable(playerNumber) ?? false)
        .toList();
  }

  List<Cell> getTargets(MapGrid mapGrid, Cell cell) {
    final cellsInRange = mapGrid.inRange(cell, range);

    switch (targetType) {
      case ActionTarget.neutralPlanet:
        return neutralPlanetCells(cellsInRange);
      case ActionTarget.enemyPlanet:
        final playerNumber = cell.ship?.state.playerNumber ?? -1;
        return enemyPlanetCells(cellsInRange, playerNumber);
      case ActionTarget.self:
        return [];
    }
  }

  void execute(Ship ship, Cell cell) {}
}

class Capture extends Action {
  Capture()
      : super(ActionType.capture, ActionTarget.enemyPlanet,
            requireAttack: true);

  @override
  void execute(Ship ship, Cell cell) {
    ship.useAttack();
    if (cell.planet == null) {
      return;
    }
    final playerNumber = ship.state.playerNumber;
    final planet = cell.planet!;
    planet.capture(playerNumber);
  }
}

class BuildColony extends Action {
  BuildColony() : super(ActionType.buildColony, ActionTarget.neutralPlanet);

  @override
  bool isDisabled(MapGrid mapGrid, Cell cell) {
    if ((cell.ship?.movePoint() ?? 0) <= 0) {
      return true;
    }

    return super.isDisabled(mapGrid, cell);
  }

  @override
  void execute(Ship ship, Cell cell) {
    if (cell.planet == null) {
      return;
    }
    final playerNumber = ship.state.playerNumber;
    cell.planet!.colonize(ship.template.engineering(), playerNumber);
    ship.setTurnOver();
  }
}

class Stay extends Action {
  Stay() : super(ActionType.stay, ActionTarget.self);

  @override
  bool isDisabled(MapGrid mapGrid, Cell cell) {
    return (cell.ship?.movePoint() ?? 0) <= 0;
  }

  @override
  void execute(Ship ship, Cell cell) {
    ship.setTurnOver();
  }
}

class SelfRepair extends Action {
  SelfRepair()
      : super(ActionType.selfRepair, ActionTarget.self,
            requireAttack: true, cooldown: 3);

  @override
  void execute(Ship ship, Cell cell) {
    ship.repair(ship.template.repairOnActionSelf());
    ship.setTurnOver();
  }
}

final actionTable = <ActionType, Action>{
  ActionType.capture: Capture(),
  ActionType.buildColony: BuildColony(),
  ActionType.stay: Stay(),
  ActionType.selfRepair: SelfRepair(),
};
