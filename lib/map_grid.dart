import 'dart:async';
import "dart:math";

import 'package:flame/components.dart';
import "package:flame/events.dart";
import 'package:flutter/services.dart';

import 'building.dart';
import 'ship.dart';
import 'scifi_game.dart';
import 'cell.dart';
import "pathfinding.dart";
import "hex.dart";
import "select_control.dart";
import "planet.dart";
import "ship_type.dart";

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
    with HasGameRef<ScifiGame>, KeyboardHandler, TapCallbacks, DragCallbacks {
  final double moveSpeed = 20;
  Vector2 direction = Vector2.zero();

  List<Cell> cells = List.empty();
  final Map<Hex, int> _hexTable = {};

  final List<Planet> planets = [];
  Pathfinding pathfinding = Pathfinding({});
  final List<Ship> shipListAll = [];
  final Map<int, List<Ship>> shipMap = {};
  late SelectControl _selectControl;

  @override
  FutureOr<void> onLoad() {
    _selectControl = SelectControlWaitForInput(game);
  }

  set selectControl(SelectControl s) {
    _selectControl.onStateExit();
    _selectControl = s;
    s.onStateEnter();
  }

  SelectControl get selectControl => _selectControl;

  /// Input block
  void blockSelect() {
    selectControl = SelectControlBlockInput(game);
  }

  /// Wait for input
  void unSelect() {
    selectControl = SelectControlWaitForInput(game);
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
    final radius = Hex.size * (game.currentGameSettings.mapSize + 1) * 2;
    return point.length <= radius;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    game.camera.moveBy(-event.localDelta);
  }

  @override
  void onTapUp(TapUpEvent event) {
    final hex = _pixelToHex(event.localPosition);

    final cellIndex = _hexTable[hex] ?? -1;
    if (cellIndex < 0) {
      return;
    }
    final cell = cells[cellIndex];
    _selectControl.onCellClick(cell);
  }

  Cell? cellAtPosition(Vector2 localPosition) {
    final hex = _pixelToHex(localPosition);

    final cellIndex = _hexTable[hex] ?? -1;
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

  FutureOr<void> initMap(List<Cell> cellList) async {
    cells = cellList;
    planets.clear();
    _hexTable.clear();
    for (final cell in cells) {
      _hexTable[cell.hex] = cell.index;
      if (cell.planet != null) {
        planets.add(cell.planet!);
      }
    }

    pathfinding = Pathfinding(_calcEdges());

    await addAll(cells);

    shipListAll.clear();
    shipMap.clear();
    for (final p in game.controller.players) {
      shipMap[p.playerNumber] = [];
      final capitalCell = getCapitalCell(p.playerNumber);
      if (capitalCell == null) {
        continue;
      }
      spawnShipAt(capitalCell, ShipType.colony, p.playerNumber);
      // spawn scout at south east
      final scoutHex = capitalCell.hex + Hex.directions[5];
      final sIndex = _hexTable[scoutHex] ?? -1;
      if (sIndex >= 0) {
        final sCell = cells[sIndex];
        spawnShipAt(sCell, ShipType.scout, p.playerNumber);
      }
    }

    selectControl = SelectControlWaitForInput(game);
  }

  Edges _calcEdges() {
    final Edges edges = {};

    for (final cell in cells) {
      edges[cell] = {};
      final ns = cell.hex.getNeighbours();
      for (final neighbour in ns) {
        final nIndex = _hexTable[neighbour] ?? -1;
        if (nIndex < 0) {
          continue;
        }
        final nCell = cells[nIndex];
        final cost = nCell.tileType.cost;
        if (cost != -1) {
          edges[cell]![nCell] = cost;
        }
      }
    }

    return edges;
  }

  moveShip(Ship ship, Cell cell) {
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

  Future<void> spawnShipAt(
      Cell cell, ShipType shipType, int playerNumber) async {
    final ship = Ship(cell, shipType, playerNumber);
    cell.ship = ship;

    shipListAll.add(ship);
    shipMap[playerNumber]!.add(ship);

    await add(ship);
  }

  Future<void> createShipAt(
      Cell cell, ShipType shipType, int playerNumber) async {
    final ship = Ship(cell, shipType, playerNumber);
    cell.ship = ship;

    shipListAll.add(ship);
    shipMap[playerNumber]!.add(ship);

    await add(ship);
    ship.setTurnOver();
  }

  Cell? getCapitalCell(int playerNumber) {
    for (final cell in cells) {
      if (cell.planet != null) {
        final planetState = cell.planet!.state;
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
        final planetState = cell.planet!.state;
        if (planetState.playerNumber == playerNumber && cell.ship == null) {
          deployableCells.add(cell);
        }
      }
    }

    return deployableCells;
  }

  List<Cell> findAttackableCells(
      Cell originalCell, int minRange, int maxRange) {
    assert(maxRange > 0, "attackRange must be greater than 0");
    final attackingPlayerNumber = originalCell.ship?.state.playerNumber ?? -1;
    final List<Cell> attackableCells = [];
    final originalHex = originalCell.hex;
    int i = max(1, minRange);
    for (; i <= maxRange; i++) {
      final ring = originalHex.cubeRing(i);
      for (final hex in ring) {
        final index = _hexTable[hex] ?? -1;
        if (index < 0) {
          continue;
        }
        final cell = cells[index];
        if (cell.ship != null &&
            cell.ship!.state.playerNumber != attackingPlayerNumber) {
          attackableCells.add(cell);
        } else if (cell.planet != null &&
            cell.planet!.attackable(attackingPlayerNumber)) {
          attackableCells.add(cell);
        }
      }
    }

    return attackableCells;
  }
}
