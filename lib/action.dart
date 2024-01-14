import 'package:flame/components.dart';

import 'planet_state.dart';
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

  bool isEnabled(MapGrid mapGrid, Cell cell) {
    if (requireAttack) {
      if (!(cell.ship?.canAttack() ?? false)) {
        return false;
      }
    }
    return getTargets(mapGrid, cell).isNotEmpty;
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
  void execute(Ship ship, Cell cell) {
    ship.useMove(1);
    if (cell.planet == null) {
      return;
    }
    final playerNumber = ship.state.playerNumber;
    final planet = cell.planet!;
    planet.colonize(playerNumber, PlanetState.oneM * 100);
    ship.dispose();
  }
}

class Stay extends Action {
  Stay() : super(ActionType.stay, ActionTarget.self);

  @override
  bool isEnabled(MapGrid mapGrid, Cell cell) {
    return (cell.ship?.movePoint() ?? 0) > 0;
  }

  @override
  void execute(Ship ship, Cell cell) {
    ship.setTurnOver();
  }
}

final actionTable = <ActionType, Action>{
  ActionType.capture: Capture(),
  ActionType.buildColony: BuildColony(),
};
