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
  final Cell cell;

  SelectControlCell(this.cell);

  @override
  void onMount() {
    game.getIt<HudState>().cell.value = cell;
    cell.planet?.select();

    super.onMount();
  }

  @override
  void onRemove() {
    cell.planet?.select();
    game.getIt<HudState>().deselectCell();
  }

  @override
  void onCellClick(Cell cell) {
    game.mapGrid.selectControl = SelectControlCell(cell);
  }
}

class SelectControlInputBlocked extends SelectControlComponent {}
