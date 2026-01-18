import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/extensions.dart';

import 'scifi_game.dart';
import 'cell.dart';
import "hex.dart";
import 'ship.dart';
import 'select_control.dart';
import 'styles.dart';
import 'game_settings.dart';

class MapGrid extends Component
    with HasGameReference<ScifiGame>, TapCallbacks, HasCollisionDetection {
  final List<Ship> ships = [];
  final fogLayer = PositionComponent(priority: 4);
  final shipLayer = PositionComponent(priority: 3);

  List<List<Cell>> cells = [];
  late SelectControlComponent _selectControl;
  late final corners = Hex.zero
      .polygonCorners()
      .map((e) => e.toOffset())
      .toList(growable: false);

  set selectControl(SelectControlComponent s) {
    _selectControl.removeFromParent();
    _selectControl = s;
    add(_selectControl);
  }

  SelectControlComponent get selectControl => _selectControl;

  void deselect() {
    selectControl = SelectControlWaitForInput();
  }

  void start(GameSettings gameSettings) {
    cells = game.g.cells;
    for (final col in cells) {
      addAll(col);
    }
  }

  void addShip(Ship ship) {
    ships.add(ship);
    shipLayer.add(ship);
  }

  void reset() {
    for (final planet in game.g.planets) {
      planet.removeFromParent();
    }
    game.g.planets.clear();
  }

  @override
  FutureOr<void> onLoad() {
    _selectControl = SelectControlWaitForInput();
    addAll([_selectControl, fogLayer, shipLayer]);

    return super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    final hex = Hex.pixelToHex(event.localPosition);
    final cell = cells[hex.x.clamp(0, cells.length - 1)][hex.y.clamp(0, cells[0].length - 1)];
    if (cell.planet != null) {
      selectControl.onPlanetClick(cell.planet!);
    } else {
      print(cell);
    }

    super.onTapUp(event);
  }

  @override
  void render(Canvas canvas) {
    for (final col in cells) {
      for (final cell in col) {
        canvas.renderAt(cell.position, (myCanvas) {
          final ns = cell.hex.getNeighbours();
          for (int i = 0; i < ns.length; i++) {
            canvas.drawLine(corners[(11 - i) % 6], corners[(12 - i) % 6],
                FlameTheme.hexBorderPaint);
          }
        });
      }
    }

    super.render(canvas);
  }
}
