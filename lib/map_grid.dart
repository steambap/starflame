import 'dart:async';
import "dart:math";

import 'package:flame/components.dart';
import "package:flame/events.dart";
import 'package:flutter/services.dart';

import 'building.dart';
import 'ship.dart';
import 'tile_type.dart';
import 'scifi_game.dart';
import 'cell.dart';
import 'edges.dart';
import "pathfinding.dart";
import "hex.dart";
import "select_control.dart";
import "planet.dart";

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
  List<Cell> cells = List.empty();
  Map<Hex, int> hexTable = {};
  final List<Planet> planets = [];
  Pathfinding pathfinding = Pathfinding({});
  List<Ship> shipListAll = List.empty(growable: true);
  Map<int, List<Ship>> fleetMap = {};
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

  /// Input block
  void blockSelect() {
    selectControl = SelectControlBlockInput(this);
  }

  /// Wait for input
  void unSelect() {
    selectControl = SelectControlWaitForInput(this);
  }

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

    final cellIndex = hexTable[hex] ?? -1;
    if (cellIndex < 0) {
      return;
    }
    final cell = cells[cellIndex];
    _selectControl.onCellClick(cell);
  }

  Cell? cellAtPosition(Vector2 localPosition) {
    final hex = _pixelToHex(localPosition);

    final cellIndex = hexTable[hex] ?? -1;
    if (cellIndex < 0) {
      return null;
    }
    return cells[cellIndex];
  }

  @override
  void update(double dt) {
    final Vector2 velocity = direction * moveSpeed;

    game.camera.moveBy(velocity);
    super.update(dt);
  }

  FutureOr<void> initMap(List<Cell> cellList) {
    cells = cellList;
    planets.clear();
    hexTable = {};
    for (final cell in cells) {
      hexTable[cell.hex] = cell.index;
      if (cell.planet != null) {
        planets.add(cell.planet!);
      }
    }
    pathfinding = Pathfinding(_calcEdges());
    return addAll(cells);
  }

  Edges _calcEdges() {
    final Edges edges = {};

    for (final cell in cells) {
      edges[cell] = {};
      final ns = cell.hex.getNeighbours();
      for (final neighbour in ns) {
        final nIndex = hexTable[neighbour] ?? -1;
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

  moveFleet(Ship ship, Cell cell) {
    final prevCell = ship.cell;
    prevCell.ship = null;

    ship.cell = cell;
    List<Cell> fromCells = List.empty();
    if (_selectControl is SelectControlCellSelected) {
      final paths = (_selectControl as SelectControlCellSelected).paths;
      if (paths.containsKey(cell)) {
        fromCells = paths[cell]!;
      }
    }
    ship.moveAnim(cell, fromCells);
    cell.ship = ship;
  }

  void createShipAt(Cell cell) {
    final ship = Ship(cell);
    cell.ship = ship;

    shipListAll.add(ship);

    add(ship);
  }

  Cell? getCapitalCell(int playerNumber) {
    for (final cell in cells) {
      if (cell.planet != null) {
        final planetState = cell.planet!.planetState;
        if (planetState.buildings.contains(Building.galacticHQ) &&
            planetState.playerNumber == playerNumber) {
          return cell;
        }
      }
    }

    return null;
  }

  List<Cell> getShipDeployableCells(int playerNumber) {
    final List<Cell> deployableCells = [];
    for (final cell in cells) {
      if (cell.planet != null) {
        final planetState = cell.planet!.planetState;
        if (planetState.playerNumber == playerNumber && cell.ship == null) {
          deployableCells.add(cell);
        }
      }
    }

    return deployableCells;
  }
}
