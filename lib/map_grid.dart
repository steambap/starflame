import 'dart:async';
import "dart:math";

import 'package:flame/components.dart';
import "package:flame/events.dart";
import "package:flame/effects.dart";
import 'package:flame/extensions.dart';

import 'game_creator.dart';
import 'ship.dart';
import "ship_blueprint.dart";
import 'scifi_game.dart';
import 'cell.dart';
import "pathfinding.dart";
import "player_state.dart";
import "hex.dart";
import "select_control.dart";
import "sector.dart";
import "styles.dart";

class MapGrid extends Component with HasGameRef<ScifiGame>, TapCallbacks {
  List<Cell> cells = List.empty();

  /// Hex to cell index
  final Map<int, int> _hexTable = {};

  List<Sector> sectors = [];
  Pathfinding pathfinding = Pathfinding({});
  final List<Ship> shipListAll = [];
  final Map<int, List<Ship>> shipMap = {};
  late SelectControl _selectControl;

  late final corners = Hex.zero
      .polygonCorners()
      .map((e) => e.toOffset())
      .toList(growable: false);
  final fogLayer = PositionComponent(priority: 3);

  @override
  FutureOr<void> onLoad() {
    _selectControl = SelectControlWaitForInput(game);
    add(fogLayer);
  }

  // Draw all hexagons in one go
  @override
  void render(Canvas canvas) {
    for (final cell in cells) {
      canvas.renderAt(cell.position, (myCanvas) {
        final ns = cell.hex.getNeighbours();
        for (int i = 0; i < ns.length; i++) {
          canvas.drawLine(corners[(11 - i) % 6], corners[(12 - i) % 6],
              FlameTheme.hexBorderPaint);
        }
      });
    }
    super.render(canvas);
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
  bool containsLocalPoint(Vector2 point) {
    return true;
  }

  @override
  void onTapUp(TapUpEvent event) {
    final hex = Hex.pixelToHex(event.localPosition);

    final cellIndex = _hexTable[hex.toInt()] ?? -1;
    if (cellIndex < 0) {
      unSelect();
      return;
    }
    final cell = cells[cellIndex];
    _selectControl.onCellClick(cell);
  }

  Cell? cellAtHex(Hex hex) {
    final cellIndex = _hexTable[hex.toInt()] ?? -1;
    if (cellIndex < 0) {
      return null;
    }
    return cells[cellIndex];
  }

  Cell? cellAtPosition(Vector2 localPosition) {
    final hex = Hex.pixelToHex(localPosition);

    return cellAtHex(hex);
  }

  void initHexTable() {
    _hexTable.clear();
    for (int i = 0; i < cells.length; i++) {
      final cell = cells[i];
      _hexTable[cell.hex.toInt()] = i;
    }
  }

  FutureOr<void> initMap(GameCreator gc) async {
    cells = gc.cells;
    sectors = gc.sectors;
    initHexTable();

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
      // spawn a scout
      final interceptor = p.blueprints[0];
      await spawnShipAt(capitalCell, p.playerNumber, interceptor);
    }

    selectControl = SelectControlWaitForInput(game);
  }

  Edges _calcEdges() {
    final Edges edges = {};

    for (final cell in cells) {
      edges[cell] = {};
      final ns = cell.hex.getNeighbours();
      for (final neighbour in ns) {
        final nIndex = _hexTable[neighbour.toInt()] ?? -1;
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

  void _moveShipHex(Ship ship, Cell cell) {
    final prevCell = cellAtHex(ship.hex);
    prevCell?.ship = null;

    ship.hex = cell.hex;
    cell.ship = ship;
  }

  void moveShip(Ship ship, Cell cell) {
    _moveShipHex(ship, cell);
    List<Cell> fromCells = List.empty();
    if (ship.cachedPaths.containsKey(cell)) {
      fromCells = ship.cachedPaths[cell]!;
    }
    final moveCost = fromCells.fold(0, (previousValue, element) {
      return previousValue + element.tileType.cost;
    });
    ship.useMove(moveCost);
    // add move animation to pool
    ship.onStartMove();
    for (final e in fromCells.reversed) {
      game.animationPool.add(() async {
        final effect =
            MoveToEffect(e.position, EffectController(duration: 0.1));
        final angle = atan2(e.position.y - ship.position.y,
                e.position.x - ship.position.x) +
            pi / 2;
        ship.sprite.angle = angle;
        ship.add(effect);
        updateVision(e, ship.visionRange());

        return effect.completed;
      });
    }
    game.animationPool.addSyncFunc(() {
      ship.onEndMove();
    }, 100);
  }

  void updateVision(Cell cell, int visionRange) {
    final hexes = cell.hex.cubeSpiral(visionRange);
    for (final hex in hexes) {
      final cell = cellAtHex(hex);
      if (cell == null) {
        continue;
      }
      final currentPlayer = game.controller.currentPlayerState();
      currentPlayer.vision.add(cell.hex);
      if (currentPlayer.playerNumber ==
          game.controller.getHumanPlayerNumber()) {
        cell.reveal();
      }
    }
  }

  Future<void> spawnShipAt(
      Cell cell, int playerNumber, ShipBlueprint blueprint) async {
    final ship = Ship(cell.hex, playerNumber, blueprint);
    cell.ship = ship;

    shipListAll.add(ship);
    shipMap[playerNumber]!.add(ship);

    await add(ship);
  }

  Future<void> createShipAt(
      Cell cell, int playerNumber, ShipBlueprint blueprint) async {
    final ship = Ship(cell.hex, playerNumber, blueprint);
    cell.ship = ship;

    shipListAll.add(ship);
    shipMap[playerNumber]!.add(ship);

    await add(ship);
    ship.setTurnOver();
  }

  Cell? getCapitalCell(int playerNumber) {
    for (final s in sectors) {
      if (s.homePlanet == playerNumber) {
        final hex = s.hex;
        final index = _hexTable[hex.toInt()] ?? -1;
        if (index < 0) {
          continue;
        }
        return cells[index];
      }
    }

    return null;
  }

  List<Cell> getShipDeployableCells(int playerNumber) {
    final List<Cell> deployableCells = [];
    for (final cell in cells) {
      if (cell.sector != null) {
        if (cell.sector?.playerNumber == playerNumber) {
          const range = Block(0, 1);
          final cellsInRange = inRange(cell, range);
          for (final cell in cellsInRange) {
            if (cell.ship == null) {
              deployableCells.add(cell);
            }
          }
        }
      }
    }

    return deployableCells;
  }

  List<Cell> inRange(Cell center, Block range) {
    final List<Cell> cellsInRange = [];
    if (range.x == 0) {
      cellsInRange.add(center);
    }
    if (range.y == 0) {
      return cellsInRange;
    }
    int i = max(1, range.x);
    for (; i <= range.y; i++) {
      final ring = center.hex.cubeRing(i);
      for (final hex in ring) {
        final index = _hexTable[hex.toInt()] ?? -1;
        if (index < 0) {
          continue;
        }
        final cell = cells[index];
        cellsInRange.add(cell);
      }
    }

    return cellsInRange;
  }

  List<Cell> findAttackableCells(Cell originalCell, Block range) {
    final attackingPlayerNumber = originalCell.ship?.state.playerNumber ?? -1;
    final List<Cell> attackableCells = [];
    final cellsInRange = inRange(originalCell, range);
    for (final cell in cellsInRange) {
      if (cell.ship != null &&
          cell.ship!.state.playerNumber != attackingPlayerNumber) {
        attackableCells.add(cell);
      } else if (cell.sector != null &&
          cell.sector!.attackable(attackingPlayerNumber)) {
        attackableCells.add(cell);
      }
    }

    return attackableCells;
  }

  void removeShip(Ship ship) {
    shipListAll.remove(ship);
    shipMap[ship.state.playerNumber]!.remove(ship);
  }

  void updateCellVisibility(PlayerState pState) {
    final playerNumber = pState.playerNumber;
    final vision = pState.vision;
    if (vision.length == cells.length) {
      return;
    }
    // Ships may have larger vision on the start of a turn due to upgrades
    for (final ship in shipMap[playerNumber] ?? List<Ship>.empty()) {
      vision.addAll(ship.vision());
    }
    if (playerNumber != game.controller.getHumanPlayerNumber()) {
      return;
    }
    // Human player vision update
    for (final cell in cells) {
      if (vision.contains(cell.hex)) {
        cell.hideFog();
      }
    }
  }

  void debugRemoveFog() {
    for (final cell in cells) {
      cell.reveal();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "cells": cells.map((e) => e.toJson()).toList(),
      "sectors": sectors.map((e) => e.toJson()).toList(),
      // ships goes here
    };
  }
}
