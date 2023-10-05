import "map_grid.dart";
import "cell.dart";
import "fleet.dart";

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
  Fleet? fleet;
  Map<Cell, List<Cell>> paths = {};

  SelectControlCellSelected(super.mapGrid, this.cell) {
    if (cell.fleets.isNotEmpty) {
      fleet = cell.fleets[0];
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

    if (fleet != null) {
      mapGrid.moveFleet(fleet!, cell);
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
