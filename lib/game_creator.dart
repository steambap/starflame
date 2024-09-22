import "dart:math";
import "package:flutter/material.dart" show Colors;

import "planet.dart";
import "hex.dart";
import "cell.dart";
import "sector.dart";
import "game_settings.dart";
import "player_state.dart";
import "tile_type.dart";
import "empire.dart";
import "data/name.dart";

const plasticRatio = 1.324717957244746;
const a1 = 1 / plasticRatio;
const a2 = 1 / (plasticRatio * plasticRatio);

List<Hex> generateHexMap(int qMax) {
  final List<Hex> hexMap = List.empty(growable: true);
  for (int q = -qMax; q <= qMax; q++) {
    final r1 = max(-qMax, -q - qMax);
    final r2 = min(qMax, -q + qMax);
    for (int r = r1; r <= r2; r++) {
      hexMap.add(Hex(q, r, -q - r));
    }
  }

  return hexMap;
}

List<List<Planet>> generatePlanets() {
  final List<List<Planet>> planets = [
    // Inner
    [Planet.economy10(), Planet.mining11()],
    [Planet.economy10(), Planet.lab10()],
    [Planet.economy11(), Planet.lab11()],
    [Planet.economy10(), Planet.lab10(), Planet.mining01()],
    [Planet.lab10(), Planet.mining10()],
    [Planet.economy10(), Planet.lab01(), Planet.mining01()],
    [Planet.economy10(), Planet.lab01(), Planet.gas10()],
    [Planet.economy10(), Planet.mining10()],
    [Planet.economy01(), Planet.gas01()],
    // Middle
    [Planet.economy10(), Planet.mining10()],
    [Planet.lab11()],
    [Planet.economy01(), Planet.lab10(), Planet.mining10()],
    [Planet.economy01(), Planet.mining01(), Planet.gas10()],
    [Planet.economy11(), Planet.lab01()],
    [Planet.mining10()],
    [Planet.economy10(), Planet.lab10()],
    [Planet.economy10(), Planet.mining10()],
    [Planet.economy10(), Planet.mining01(), Planet.gas10()],
    [Planet.lab10(), Planet.mining01(), Planet.gas01()],
    // Outer
    [Planet.economy10(), Planet.lab10(), Planet.mining01()],
    [Planet.economy01(), Planet.lab01(), Planet.mining10()],
    [Planet.economy01(), Planet.lab01(), Planet.gas10()],
    [Planet.economy01(), Planet.mining10()],
    [Planet.lab10(), Planet.mining10()],
    [Planet.economy10(), Planet.mining10()],
    [Planet.economy10(), Planet.lab01()],
    [Planet.lab10(), Planet.mining01()],
    [Planet.economy10(), Planet.lab01()],
    [Planet.lab10(), Planet.mining10()],
    [Planet.mining10()],
    [Planet.mining10()],
    [Planet.gas10()],
    [Planet.gas10()],
    [Planet.economy11()],
    [Planet.mining01(), Planet.gas10()],
  ];

  return planets;
}

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

  List<String> _names = [];
  List<List<Planet>> _planets = [];

  void create(GameSettings gameSettings) {
    this.gameSettings = gameSettings;
    rand = Random(gameSettings.seed);

    cells.clear();
    sectors.clear();
    homes.clear();
    s1 = rand.nextDouble();
    s2 = rand.nextDouble();

    final hexList = generateHexMap(gameSettings.mapSize);

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
      if ((hex.distance(Hex.zero) > (gameSettings.mapSize - 3)) &&
          homes.length < gameSettings.players.length) {
        final player = gameSettings.players[homes.length];
        player.vision.add(cell.hex);
        homes.add(cell.hex);
        final sector = Sector(cell.hex,
            planets: [Planet.gas10(), Planet.mining10(), Planet.lab11()]);
        sectors.add(sector);
        cell.sector = sector;
        sector.setHome(player.playerNumber);
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

    _prepareNames();
    for (final s in sectors) {
      s.displayName = _nextName();
    }
  }

  void _createPlanets(Cell cell) {
    final sector = Sector(cell.hex, planets: _nextPlanets());
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
    final q = (xn * (qMax * 2 + 1) - qMax).floor();
    final r1 = max(-qMax, -q - qMax);
    final r2 = min(qMax, -q + qMax);
    final r = (yn * (r2 - r1 + 1) + r1).floor();

    return Hex(q, r, -q - r);
  }

  void _preparePlanets() {
    _planets = generatePlanets();
    _planets.shuffle(rand);
  }

  List<Planet> _nextPlanets() {
    if (_planets.isEmpty) {
      _preparePlanets();
    }

    return _planets.removeLast();
  }

  void _prepareNames() {
    _names = List.from(planetNames);
    _names.shuffle(rand);
  }

  String _nextName() {
    if (_names.isNotEmpty) {
      return _names.removeLast();
    }

    final i = rand.nextInt(1013) + 42;

    return "Kepler-$i";
  }

  List<PlayerState> getTestPlayers(GameSettings gameSettings) {
    final humanPlayer = PlayerState(0, false)
      ..credit = gameSettings.playerStartingCredit
      ..empire = Empire.getEmpire("terranEmpire")
      ..color = Colors.blue;
    final testAI = PlayerState(1, true)
      ..credit = gameSettings.playerStartingCredit
      ..empire = Empire.getEmpire("terranKindom")
      ..color = Colors.red;

    return [humanPlayer, testAI];
  }
}
