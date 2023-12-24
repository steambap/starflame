import "map_grid.dart";
import "cell.dart";
import 'ship.dart';
import "ship_type.dart";

sealed class SelectControl {
  final MapGrid mapGrid;

  SelectControl(this.mapGrid);

  void onCellClick(Cell cell) {}

  void onStateEnter() {}

  void onStateExit() {}
}

class SelectControlBlockInput extends SelectControl {
  SelectControlBlockInput(super.mapGrid);
}

class SelectControlWaitForInput extends SelectControl {
  SelectControlWaitForInput(super.mapGrid);

  @override
  void onCellClick(Cell cell) {
    mapGrid.selectControl = SelectControlCellSelected(mapGrid, cell);
  }
}

class SelectControlCellSelected extends SelectControl {
  Cell cell;
  Ship? ship;
  Map<Cell, List<Cell>> paths = {};

  SelectControlCellSelected(super.mapGrid, this.cell) {
    if (cell.ship != null) {
      ship = cell.ship;
      paths = mapGrid.pathfinding.findAllPath(cell, 2);
    }
  }

  @override
  onCellClick(Cell cell) {
    if (this.cell == cell) {
      return;
    }
    if (!paths.containsKey(cell)) {
      mapGrid.selectControl = SelectControlCellSelected(mapGrid, cell);
      return;
    }

    if (ship != null) {
      mapGrid.moveFleet(ship!, cell);
      mapGrid.selectControl = SelectControlWaitForInput(mapGrid);
    }
  }

  @override
  void onStateEnter() {
    for (final cell in paths.keys) {
      cell.markAsHighlight();
    }
  }

  @override
  void onStateExit() {
    for (final cell in paths.keys) {
      cell.unmark();
    }
  }
}

class SelectControlCreateShip extends SelectControl {
  final ShipType shipType;
  Map<Cell, bool> cells = {};
  SelectControlCreateShip(this.shipType, super.mapGrid) {
    final deployableCells = mapGrid.getShipDeployableCells(mapGrid.game.gameStateController.getHumanPlayerNumber());
    for (final cell in deployableCells) {
      cells[cell] = true;
    }
  }

  @override
  void onCellClick(Cell cell) {
    if (cells.containsKey(cell)) {
      mapGrid.game.gameStateController.createShip(cell, shipType, mapGrid.game.gameStateController.getHumanPlayerNumber());
    }
    mapGrid.selectControl = SelectControlWaitForInput(mapGrid);
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
