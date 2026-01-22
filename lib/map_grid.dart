import 'dart:async';
import 'dart:math';

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
  static const double horiz = 3 / 2 * Hex.size;
  static final double vert = sqrt(3) * Hex.size;
  final List<Ship> ships = [];
  final fogLayer = PositionComponent(priority: 5);
  final labelLayer = PositionComponent(priority: 4);
  final shipLayer = PositionComponent(priority: 3);

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

  void blockSelect() {
    selectControl = SelectControlInputBlocked();
  }

  void deselect() {
    selectControl = SelectControlWaitForInput();
  }

  void start(GameSettings gameSettings) {
    for (final List<Cell> col in game.g.cells) {
      addAll(col);
    }

    for (final planet in game.g.planets) {
      labelLayer.add(TextComponent(
        text: planet.name,
        textRenderer: FlameTheme.text16pale,
        position: planet.hex.toPixel() + Vector2(0, -48),
        anchor: Anchor.center,
      ));
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
    addAll([_selectControl, fogLayer, labelLayer, shipLayer]);

    return super.onLoad();
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    return true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    final hex = pixelToHex(event.localPosition);

    final cell = game.g.cells[hex.x][hex.y];
    selectControl.onCellClick(cell);

    super.onTapUp(event);
  }

  @override
  void render(Canvas canvas) {
    for (final col in game.g.cells) {
      for (final cell in col) {
        canvas.renderAt(cell.position, (myCanvas) {
          final ns = cell.hex.getNeighbours();
          for (int i = 0; i < ns.length; i++) {
            canvas.drawLine(
              corners[(11 - i) % 6],
              corners[(12 - i) % 6],
              FlameTheme.hexBorderPaint,
            );
          }
        });
      }
    }

    super.render(canvas);
  }

  Hex pixelToHex(Vector2 pixel) {
    final cells = game.g.cells;
    final int x = ((pixel.x + horiz * 0.5) / horiz).floor().clamp(
      0,
      cells.length - 1,
    );
    final int y = ((pixel.y + vert * 0.5 - (x & 1) * vert * 0.5) / vert)
        .floor()
        .clamp(0, cells[0].length - 1);

    return Hex(x, y);
  }
}
