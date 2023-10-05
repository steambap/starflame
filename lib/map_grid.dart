import 'dart:async';
import "dart:math";

import 'package:flame/components.dart';
import "package:flame/events.dart";
import 'package:flutter/services.dart';
import 'package:starfury/fleet.dart';

import 'tile_type.dart';
import 'scifi_game.dart';
import 'cell.dart';
import 'edges.dart';
import "pathfinding.dart";
import "hex.dart";
import "select_control.dart";

// https://www.redblobgames.com/grids/hexagons/#pixel-to-hex
Hex _pixelToHex(Vector2 pixel) {
  final double x = (sqrt(3) / 3 * pixel.x - 1 / 3 * pixel.y) / Hex.size;
  final double y = (2 / 3 * pixel.y) / Hex.size;
  final Hex hex = _cubeRound(Vector3(x, y, -x - y));

  return hex;
}

// https://www.redblobgames.com/grids/hexagons/#rounding
Hex _cubeRound(Vector3 frac) {
  int q = frac.x.round();
  int r = frac.y.round();
  int s = frac.z.round();

  final qDiff = (q - frac.x).abs();
  final rDiff = (r - frac.y).abs();
  final sDiff = (s - frac.z).abs();

  if ((qDiff > rDiff) && (qDiff > sDiff)) {
    q = -r - s;
  } else if (rDiff > sDiff) {
    r = -q - s;
  } else {
    s = -q - r;
  }

  return Hex(q, r, s);
}

class MapGrid extends Component
    with HasGameRef<ScifiGame>, KeyboardHandler, TapCallbacks {
  static Map<TileType, int> costMap = {
    TileType.empty: 1,
    TileType.alphaWormHole: 1,
    TileType.betaWormHole: 1,
    TileType.asteroidField: 2,
    TileType.nebula: 2,
  };

  final double moveSpeed = 20;
  Vector2 direction = Vector2.zero();
  List<Cell> cells = List.empty(growable: true);
  Pathfinding pathfinding = Pathfinding({});
  List<Fleet> fleetListAll = List.empty(growable: true);
  Map<int, List<Fleet>> fleetMap = {};
  late SelectControl _selectControl;

  MapGrid() {
    _selectControl = SelectControlWaitForInput(this);
  }

  set selectControl(SelectControl s) {
    _selectControl.onStateExit();
    _selectControl = s;
    s.onStateEnter();
  }

  SelectControl get selectControl => _selectControl;

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    direction = Vector2.zero();
    direction.x += (keysPressed.contains(LogicalKeyboardKey.keyA) ||
            keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    direction.x += (keysPressed.contains(LogicalKeyboardKey.keyD) ||
            keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;

    direction.y += (keysPressed.contains(LogicalKeyboardKey.keyW) ||
            keysPressed.contains(LogicalKeyboardKey.arrowUp))
        ? -1
        : 0;
    direction.y += (keysPressed.contains(LogicalKeyboardKey.keyS) ||
            keysPressed.contains(LogicalKeyboardKey.arrowDown))
        ? 1
        : 0;

    return true;
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    const halfWidth = Hex.size * 20;
    return point.x >= -halfWidth &&
        point.x <= halfWidth &&
        point.y >= -halfWidth &&
        point.y <= halfWidth;
  }

  @override
  void onTapUp(TapUpEvent event) {
    final hex = _pixelToHex(event.localPosition);

    final cellIndex = cells.indexWhere((cell) => cell.hex == hex);
    if (cellIndex < 0) {
      return;
    }
    final cell = cells[cellIndex];
    _selectControl.onCellClick(cell);
  }

  @override
  void update(double dt) {
    final Vector2 velocity = direction * moveSpeed;

    game.camera.moveBy(velocity);
    super.update(dt);
  }

  @override
  FutureOr<void> onLoad() {
    cells = game.gameCreator.createTutorial();
    pathfinding = Pathfinding(_calcEdges());
    for (final cell in cells) {
      add(cell);
    }

    createFleetAt(cells[0]);
  }

  Edges _calcEdges() {
    final Edges edges = {};

    for (final cell in cells) {
      edges[cell] = {};
      final ns = cell.hex.getNeighbours();
      for (final neighbour in ns) {
        final nIndex = cells.indexWhere((element) => element.hex == neighbour);
        if (nIndex < 0) {
          continue;
        }
        final nCell = cells[nIndex];
        final cost = costMap[nCell.tileType];
        if (cost != null) {
          edges[cell]![nCell] = cost;
        }
      }
    }

    return edges;
  }

  moveFleet(Fleet fleet, Cell cell) {
    final prevCell = fleet.cell;
    prevCell.fleets.remove(fleet);

    fleet.cell = cell;
    List<Cell> fromCells = List.empty();
    if (_selectControl is SelectControlCellSelected) {
      final paths = (_selectControl as SelectControlCellSelected).paths;
      if (paths.containsKey(cell)) {
        fromCells = paths[cell]!;
      }
    }
    fleet.moveAnim(cell, fromCells);
    cell.fleets.add(fleet);
  }

  createFleetAt(Cell cell) {
    final fleet = Fleet(cell);
    cell.fleets.add(fleet);

    fleetListAll.add(fleet);

    add(fleet);
  }
}
