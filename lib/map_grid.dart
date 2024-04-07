import 'dart:async';
import "dart:math";
import 'dart:ui';

import 'package:flame/components.dart';
import "package:flame/events.dart";
import 'package:flame/effects.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/services.dart';
import 'package:starfury/game_creator.dart';
import 'package:starfury/menu_planet_cmd.dart';

import 'ship.dart';
import 'scifi_game.dart';
import 'cell.dart';
import "pathfinding.dart";
import "hex.dart";
import "select_control.dart";
import "planet.dart";
import "tile_type.dart";
import "theme.dart" show textDamage, hexBorderPaint, sectionBorderPaint;

// https://www.redblobgames.com/grids/hexagons/#pixel-to-hex
Hex _pixelToHex(Vector2 pixel) {
  final double x = (sqrt(3) / 3 * pixel.x - 1 / 3 * pixel.y) / Hex.size;
  final double y = (2 / 3 * pixel.y) / Hex.size;
  final Hex hex = Hex.cubeRound(Vector3(x, y, -x - y));

  return hex;
}

class MapGrid extends Component
    with HasGameRef<ScifiGame>, KeyboardHandler, TapCallbacks, DragCallbacks {
  final tileSize = Vector2.all(72);
  final double moveSpeed = 20;
  Vector2 direction = Vector2.zero();

  List<Cell> cells = List.empty();

  /// Hex to cell index
  Map<int, int> _hexTable = {};
  late final Sprite nebula;
  late final List<Sprite> asteroids;
  late final Sprite gravityRift;

  List<Planet> planets = [];
  Pathfinding pathfinding = Pathfinding({});
  final List<Ship> shipListAll = [];
  final Map<int, List<Ship>> shipMap = {};
  late SelectControl _selectControl;
  MenuPlanetCmd? _menuPlanetCmd;

  @override
  FutureOr<void> onLoad() {
    _selectControl = SelectControlWaitForInput(game);
    nebula = Sprite(game.images.fromCache("nebula.png"));
    gravityRift = Sprite(game.images.fromCache("gravity_rift.png"));
    final asteroidImg = game.images.fromCache("asteroid.png");
    asteroids = [
      Sprite(asteroidImg, srcPosition: Vector2(0, 0), srcSize: tileSize),
      Sprite(asteroidImg, srcPosition: Vector2(72, 0), srcSize: tileSize),
      Sprite(asteroidImg, srcPosition: Vector2(144, 0), srcSize: tileSize),
    ];
  }

  // Draw all hexagons in one go
  @override
  void render(Canvas canvas) {
    final corners = Hex.zero
        .polygonCorners()
        .map((e) => e.toOffset())
        .toList(growable: false);

    for (final cell in cells) {
      canvas.save();
      canvas.translate(cell.position.x, cell.position.y);

      final ns = cell.hex.getNeighbours();
      for (int i = 0; i < ns.length; i++) {
        final n = ns[i];
        Paint paint = sectionBorderPaint;
        if (_hexTable.containsKey(n.toInt())) {
          final nCell = cells[_hexTable[n.toInt()]!];
          if (cell.sector == nCell.sector) {
            paint = hexBorderPaint;
          }
        }

        canvas.drawLine(corners[(11 - i) % 6], corners[(12 - i) % 6], paint);
      }
      // draw tile
      final t = cell.tileType;
      if (t == TileType.gravityRift) {
        gravityRift.render(canvas, size: tileSize, anchor: Anchor.center);
      } else if (t == TileType.nebula) {
        nebula.render(canvas, size: tileSize, anchor: Anchor.center);
      } else if (t == TileType.asteroidField) {
        final index = cell.hex.q % 3;
        asteroids[index].render(canvas, size: tileSize, anchor: Anchor.center);
      }

      canvas.restore();
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
  bool onKeyEvent(KeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
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

    final cellIndex = _hexTable[hex.toInt()] ?? -1;
    if (cellIndex < 0) {
      return;
    }
    final cell = cells[cellIndex];
    _selectControl.onCellClick(cell);
  }

  Cell? cellAtPosition(Vector2 localPosition) {
    final hex = _pixelToHex(localPosition);

    final cellIndex = _hexTable[hex.toInt()] ?? -1;
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

  FutureOr<void> initMap(GameCreator gc) async {
    cells = gc.cells;
    _hexTable = gc.hexTable;
    planets = gc.planets;

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
      spawnShipAt(capitalCell, p.playerNumber);
      // spawn scout at south east
      final scoutHex = capitalCell.hex + Hex.directions[5];
      final sIndex = _hexTable[scoutHex.toInt()] ?? -1;
      if (sIndex >= 0) {
        final sCell = cells[sIndex];
        spawnShipAt(sCell, p.playerNumber);
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
      Cell cell, int playerNumber) async {
    final ship = Ship(cell, playerNumber);
    cell.ship = ship;

    shipListAll.add(ship);
    shipMap[playerNumber]!.add(ship);

    await add(ship);
  }

  Future<void> createShipAt(
      Cell cell, int playerNumber) async {
    final ship = Ship(cell, playerNumber);
    cell.ship = ship;

    shipListAll.add(ship);
    shipMap[playerNumber]!.add(ship);

    await add(ship);
    ship.setTurnOver();
  }

  Cell? getCapitalCell(int playerNumber) {
    for (final s in planets) {
      if (s.homePlanet && s.playerNumber == playerNumber) {
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
      if (cell.planet != null) {
        if (cell.planet?.playerNumber == playerNumber) {
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
      }
    }

    return attackableCells;
  }

  void removeShip(Ship ship) {
    shipListAll.remove(ship);
    shipMap[ship.state.playerNumber]!.remove(ship);
  }

  void resolveCombat(Ship ship, Cell cell) {
    if (cell.ship != null) {
      const attackingPower = 999;
      int damage = attackingPower *
          (ship.state.playerNumber == game.controller.getHumanPlayerNumber()
              ? 3
              : 1);
      ship.useAttack();
      cell.ship?.takeDamage(damage);
      TextComponent text = TextComponent(
          text: "-${damage.toString()}",
          textRenderer: textDamage,
          anchor: Anchor.center,
          position: cell.position);
      add(text);
      final removeEff = RemoveEffect(delay: 0.5);
      final moveEff = MoveByEffect(
        Vector2(0, -18),
        EffectController(duration: 0.5),
      );
      text.addAll([removeEff, moveEff]);
    } else if (cell.planet != null) {
      // TODO: planet siege
    }
  }

  void renderPlanetMenu(Planet? planet) {
    if (planet == null) {
      _menuPlanetCmd?.removeFromParent();
      return;
    }

    _menuPlanetCmd = MenuPlanetCmd(planet);
    _menuPlanetCmd!.position = planet.hex.toPixel();
    add(_menuPlanetCmd!);
  }
}
