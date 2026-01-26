import 'package:flame/components.dart';

import 'cell.dart';
import 'scifi_game.dart';
import 'hud_state.dart';
import 'map_grid.dart';

class SelectControlComponent extends Component
    with HasGameReference<ScifiGame>, ParentIsA<MapGrid> {
  void onCellClick(Cell cell) {}
}

class SelectControlWaitForInput extends SelectControlComponent {
  @override
  void onCellClick(Cell cell) {
    game.mapGrid.selectControl = SelectControlCell(cell);
  }
}

class SelectControlCell extends SelectControlComponent {
  final Cell selected;
  late final Map<Cell, List<Cell>> cachedPaths;

  SelectControlCell(this.selected);

  @override
  void onMount() {
    game.getIt<HudState>().cell.value = selected;
    selected.planet?.select();
    _calcShipPaths();

    super.onMount();
  }

  @override
  void onRemove() {
    selected.planet?.deselect();
    game.getIt<HudState>().deselectCell();

    for (final cell in cachedPaths.keys) {
      cell.unmark();
    }
  }

  @override
  void onCellClick(Cell cell) {
    if (cachedPaths.containsKey(cell)) {
      game.mapGrid.moveShip(selected.ship!, cell);
      game.mapGrid.selectControl = SelectControlWaitForInput();
    } else {
      game.mapGrid.selectControl = SelectControlCell(cell);
    }
  }

  void _calcShipPaths() {
    if (selected.ship == null) {
      cachedPaths = const {};
      return;
    }

    final ship = selected.ship!;
    final playerNumber = ship.playerIdx;
    if (game.g.humanPlayerIdx != playerNumber) {
      cachedPaths = const {};
      return;
    }

    cachedPaths = game.mapGrid.findAllPath(selected, playerNumber, 40);

    for (final cell in cachedPaths.keys) {
      cell.markAsHighlight();
    }
  }
}

class SelectControlInputBlocked extends SelectControlComponent {}
