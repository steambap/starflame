import "scifi_game.dart";
import "cell.dart";
import 'ship.dart';
import "ship_type.dart";

sealed class SelectControl {
  final ScifiGame game;

  SelectControl(this.game);

  void onCellClick(Cell cell) {}

  void onStateEnter() {}

  void onStateExit() {}
}

class SelectControlBlockInput extends SelectControl {
  SelectControlBlockInput(super.game);
}

class SelectControlWaitForInput extends SelectControl {
  SelectControlWaitForInput(super.game);

  @override
  void onCellClick(Cell cell) {
    game.mapGrid.selectControl = SelectControlCellSelected(game, cell);
  }
}

class SelectControlCellSelected extends SelectControl {
  Cell cell;
  Ship? ship;
  Map<Cell, List<Cell>> paths = {};
  List<Cell> attackableCells = [];

  SelectControlCellSelected(super.game, this.cell) {
    if (cell.ship != null) {
      ship = cell.ship;
      final shipOwner = ship?.state.playerNumber ?? -1;
      if (game.controller.getHumanPlayerNumber() == shipOwner) {
        paths =
            game.mapGrid.pathfinding.findAllPath(cell, cell.ship!.movePoint());
        if (ship!.canAttack()) {
          final range = game.shipDataController.attackRange(ship!.state.type);
          attackableCells =
              game.mapGrid.findAttackableCells(cell, range.$1, range.$2);
        }
      }
    }
  }

  @override
  onCellClick(Cell cell) {
    if (this.cell == cell) {
      return;
    }
    if (!paths.containsKey(cell)) {
      game.mapGrid.selectControl = SelectControlCellSelected(game, cell);
      return;
    }

    if (ship != null) {
      game.mapGrid.moveShip(ship!, cell);
      game.mapGrid.selectControl = SelectControlWaitForInput(game);
    }
  }

  @override
  void onStateEnter() {
    for (final cell in paths.keys) {
      final movePoint = ship!.movePoint() - paths[cell]!.length;
      cell.markAsHighlight(movePoint);
    }
    for (final cell in attackableCells) {
      cell.markAsTarget();
    }
  }

  @override
  void onStateExit() {
    for (final cell in paths.keys) {
      cell.unmark();
    }
    for (final cell in attackableCells) {
      cell.unmark();
    }
  }
}

class SelectControlCreateShip extends SelectControl {
  final ShipType shipType;
  Map<Cell, bool> cells = {};
  SelectControlCreateShip(this.shipType, super.game) {
    final deployableCells = game.mapGrid
        .getShipDeployableCells(game.controller.getHumanPlayerNumber());
    for (final cell in deployableCells) {
      cells[cell] = true;
    }
  }

  @override
  void onCellClick(Cell cell) {
    if (cells.containsKey(cell)) {
      game.controller
          .createShip(cell, shipType, game.controller.getHumanPlayerNumber());
    }
    game.mapGrid.selectControl = SelectControlWaitForInput(game);
  }

  @override
  void onStateEnter() {
    for (final cell in cells.keys) {
      cell.markAsHighlight();
    }
  }

  @override
  void onStateExit() {
    for (final cell in cells.keys) {
      cell.unmark();
    }
  }
}
