import "dart:math";
import "package:flutter/material.dart" show Colors;
import 'package:flame/game.dart';

import "planet.dart";
import "hex.dart";
import "cell.dart";
import "star.dart";
import "sector.dart";
import "game_settings.dart";
import "player_state.dart";
import "tile_type.dart";
import "empire.dart";

const plasticRatio = 1.324717957244746;
const a1 = 1 / plasticRatio;
const a2 = 1 / (plasticRatio * plasticRatio);

class GameCreator {
  late GameSettings gameSettings;
  late Random rand;

  final List<Cell> cells = [];

  /// Hex to cell index
  final Map<int, int> _hexTable = {};
  final List<Sector> sectors = [];
  final List<Hex> homes = [];
  double s1 = 0;
  double s2 = 0;

  void create(GameSettings gameSettings) {
    this.gameSettings = gameSettings;
    rand = Random(gameSettings.seed);

    cells.clear();
    sectors.clear();
    homes.clear();
    s1 = rand.nextDouble();
    s2 = rand.nextDouble();

    final hexList = _generateHexMap();

    for (int i = 0; i < hexList.length; i++) {
      final hex = hexList[i];
      final cell = Cell(i, hex);
      cells.add(cell);
      _hexTable[hex.toInt()] = i;
    }

    int j = -1;
    while (sectors.length < gameSettings.numOfPlanets) {
      j += 1;
      final hex = _nextHex(j);
      for (final s in sectors) {
        if (s.hex == hex) {
          continue;
        }
      }

      final cell = cells[_hexTable[hex.toInt()]!];
      if (homes.length < gameSettings.players.length) {
        final player = gameSettings.players[homes.length];
        player.vision.add(cell.hex);
        homes.add(cell.hex);
        final sector = Sector(cell.hex, StarType.yellow, planets: [
          Planet(PlanetType.habitable, 0, isUnique: true, name: "Terran"),
          Planet(PlanetType.habitable, 1),
          Planet(PlanetType.habitable, 1),
          Planet(PlanetType.habitable, 2),
          Planet(PlanetType.habitable, 2),
          Planet(PlanetType.inhabitable, 0),
          Planet(PlanetType.inhabitable, 1),
          Planet(PlanetType.inhabitable, 2),
        ]);
        sectors.add(sector);
        cell.sector = sector;
        sector.setHome(player);
      } else {
        _createPlanets(cell);
      }
    }
    // fill the rest
    for (final cell in cells) {
      if (cell.sector == null) {
        _createTile(cell);
      }
    }

    starGenerator.prepareNames(rand);
    for (final s in sectors) {
      s.displayName = starGenerator.nextName(s.starType, rand);
    }
  }

  List<Hex> _generateHexMap() {
    final List<Hex> hexMap = [];

    for (int row = 0; row < gameSettings.mapSize; row++) {
      final isEvenRow = row % 2 == 0;
      final endCol =
          isEvenRow ? gameSettings.mapSize : gameSettings.mapSize + 1;
      for (int col = 0; col < endCol; col++) {
        final hex = Hex.evenrToHex(col, row);
        hexMap.add(hex);
      }
    }

    return hexMap;
  }

  void _createPlanets(Cell cell) {
    final starAndPlanets = starGenerator.generateStarAndPlanets(rand);
    final sector = Sector(cell.hex, starAndPlanets.starType,
        planets: starAndPlanets.planets);
    sectors.add(sector);
    cell.sector = sector;
  }

  void _createTile(Cell cell) {
    final num = rand.nextDouble();

    if (num >= 0.8964) {
      cell.tileType = TileType.asteroidField;
    } else if (num > 0.813) {
      cell.tileType = TileType.gravityRift;
    } else if (num < 0.1013) {
      cell.tileType = TileType.nebula;
    }
  }

  Hex _nextHex(int i) {
    final xn = (s1 + a1 * i) % 1;
    final yn = (s2 + a2 * i) % 1;
    final qMax = gameSettings.mapSize;
    final x = sqrt(3) * Hex.size * qMax * xn;
    final y = 1.5 * Hex.size * qMax * yn;

    return Hex.pixelToHex(Vector2(x, y));
  }

  List<PlayerState> getTestPlayers(GameSettings gameSettings) {
    final humanPlayer = PlayerState(0, false)
      ..energy = gameSettings.playerStartingCredit
      ..empire = Empire.getEmpire(Faction.terranTechnocracy)
      ..color = Colors.blue;
    final testAI = PlayerState(1, true)
      ..energy = gameSettings.playerStartingCredit
      ..empire = Empire.getEmpire(Faction.terranSeparatists)
      ..color = Colors.red;

    return [humanPlayer, testAI];
  }
}
