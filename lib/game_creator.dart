import "dart:collection";
import "dart:math";
import "package:flutter/material.dart" show Colors;

import "planet.dart";
import "hex.dart";
import "cell.dart";
import "sector.dart";
import "game_settings.dart";
import "player_state.dart";
import "tile_type.dart";
import "planet_type.dart";
import "empire.dart";
import "data/name.dart";

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

final asteroidStyles = [
  [Hex.directions[0], Hex.directions[3]],
  [Hex.directions[1], Hex.directions[4]],
  [Hex.directions[2], Hex.directions[5]],
  [Hex.directions[3], Hex.directions[0]],
  [Hex.directions[0], Hex.directions[1], Hex.directions[3]],
  [Hex.directions[0], Hex.directions[2], Hex.directions[3]],
  [Hex.directions[0], Hex.directions[4], Hex.directions[3]],
  [Hex.directions[0], Hex.directions[5], Hex.directions[3]],
  ...Hex.directions.map((e) => [e]),
];

class GameCreator {
  static const minDistanceSector = 5;
  static const numOfSector = 4;
  static const lloydIterations = 2;
  static const objInSector = 11;

  late GameSettings gameSettings;
  late Random rand;
  late final int _weight = _getTotalWeight();

  final List<Cell> cells = [];
  List<Hex> hexList = [];
  final Map<int, int> hexTable = {};
  final List<Planet> planets = [];
  final Map<Hex, Sector> sectorTable = {};
  Map<Hex, Hex> _lastFillMap = {};

  List<String> _names = [];

  void create(GameSettings gameSettings) {
    this.gameSettings = gameSettings;
    rand = Random(gameSettings.seed);

    cells.clear();
    hexList.clear();
    hexTable.clear();
    planets.clear();
    sectorTable.clear();

    hexList = generateHexMap(gameSettings.mapSize);
    for (int i = 0; i < hexList.length; i++) {
      final hex = hexList[i];
      hexTable[hex.toInt()] = i;
      final cell = Cell(i, hex);
      cells.add(cell);
    }

    // Generate sectors
    final starter = _createStart(minDistanceSector, numOfSector);
    Map<Hex, List<Hex>> relaxed = _relax(starter);
    for (int i = 0; i < lloydIterations - 1; i++) {
      relaxed = _relax(relaxed.keys.toList());
    }

    for (final hex in relaxed.keys) {
      final sector = Sector();
      sectorTable[hex] = sector;
    }
    // set cell sector
    for (final key in _lastFillMap.keys) {
      final value = _lastFillMap[key]!;
      cells[hexTable[key.toInt()]!].sector = value;
    }
    // Generate planets and objects
    for (final center in relaxed.keys) {
      _createObjectInSector(center, relaxed[center]!);
    }

    _assignHomePlanet();

    _prepareNames();
    for (final s in planets) {
      s.displayName = _nextName();
    }
  }

  Map<Hex, List<Hex>> _relax(List<Hex> starter) {
    final fillResult = _floodFillHex(starter);
    final Map<Hex, List<Hex>> newMap = {};
    for (final hexes in fillResult.values) {
      final center = Hex.center(hexes);
      newMap[center] = hexes;
    }

    return newMap;
  }

  Map<Hex, List<Hex>> _floodFillHex(List<Hex> starter) {
    final Map<Hex, List<Hex>> result = {};
    final Queue<Hex> queue = Queue.from(starter);
    final Map<Hex, Hex> fillMap = {};

    for (final hex in starter) {
      fillMap[hex] = hex;
    }

    while (queue.isNotEmpty) {
      final hex = queue.removeFirst();
      final neighbors = hex.getNeighbours();
      for (final neighbor in neighbors) {
        if (!hexTable.containsKey(neighbor.toInt())) {
          continue;
        }
        if (!fillMap.containsKey(neighbor)) {
          fillMap[neighbor] = fillMap[hex]!;
          queue.add(neighbor);
        }
      }
    }

    _lastFillMap = fillMap;

    for (final key in fillMap.keys) {
      final value = fillMap[key]!;
      result.putIfAbsent(value, () => []);
      result[value]!.add(key);
    }

    return result;
  }

  List<Hex> _createStart(int minDistance, int count) {
    final List<Hex> result = [];

    loop:
    while (result.length < count) {
      final hex = hexList[rand.nextInt(hexList.length)];
      if (hex.distance(Hex.zero) > (gameSettings.mapSize - 1)) {
        continue loop;
      }

      for (final other in result) {
        if (hex.distance(other) < minDistance) {
          continue loop;
        }
      }

      result.add(hex);
    }

    return result;
  }

  _createObjectInSector(Hex center, List<Hex> hexes) {
    final List<Hex> points = List.from(hexes);
    points.shuffle(rand);
    final List<Hex> objects = [];
    final int additionalObjNum = max(0, (hexes.length - 154) ~/ 10);
    final int totalObjNum = objInSector + additionalObjNum;

    while (objects.length < totalObjNum && points.length > 7) {
      final hex = points.removeLast();
      final ns = hex.getNeighbours();
      bool valid = true;
      for (final n in ns) {
        if (!hexTable.containsKey(n.toInt()) || !points.contains(n)) {
          valid = false;
          break;
        }
      }
      if (valid) {
        objects.add(hex);
        // mark as used
        for (final element in ns) {
          points.remove(element);
        }
      }
    }
    // Spawn planets closer to center
    objects.sort((a, b) => a.distance(center).compareTo(b.distance(center)));

    int numOfPlanetSize = rand.nextInt(5) + 9;
    for (final hex in objects) {
      final idx = hexTable[hex.toInt()]!;
      final cell = cells[idx];
      if (numOfPlanetSize > 0) {
        numOfPlanetSize -= _createPlanets(cell);
        sectorTable[center]!.planetPosList.add(hex);
      } else {
        _createTile(cell);
      }
    }
    // Player should spawn further from galaxy center
    sectorTable[center]!
        .planetPosList
        .sort((a, b) => b.distance(Hex.zero).compareTo(a.distance(Hex.zero)));
  }

  int _createPlanets(Cell cell) {
    final size = rand.nextInt(3);

    final s =
        Planet(_getRandPlanet(rand), cell.hex, cell.sector, planetSize: size);
    cell.planet = s;
    planets.add(s);

    return size + 3;
  }

  void _createTile(Cell cell) {
    // 50% asteroid field, 25% nebula, 25% gravity rift
    final num = rand.nextInt(4);

    if (num == 0) {
      _setAsteroidField(cell);
    } else if (num == 1) {
      _setNebula(cell);
    } else if (num == 2) {
      _setGravityRift(cell);
    } else {
      _setAsteroidField(cell);
    }
  }

  void _setAsteroidField(Cell cell) {
    cell.tileType = TileType.asteroidField;

    final style = asteroidStyles[rand.nextInt(asteroidStyles.length)];
    final ns = style.map((e) => e + cell.hex).toList();
    for (final n in ns) {
      final idx = hexTable[n.toInt()]!;
      cells[idx].tileType = TileType.asteroidField;
    }
  }

  void _setNebula(Cell cell) {
    cell.tileType = TileType.nebula;
    final ns = cell.hex.getNeighbours();

    for (final n in ns) {
      if (hexTable.containsKey(n.toInt())) {
        final idx = hexTable[n.toInt()]!;
        cells[idx].tileType = TileType.nebula;
      }
    }
  }

  void _setGravityRift(Cell cell) {
    cell.tileType = TileType.gravityRift;
  }

  _assignHomePlanet() {
    final List<Hex> sectors = sectorTable.keys.toList();
    sectors.shuffle(rand);
    for (int i = 0; i < gameSettings.players.length; i++) {
      final player = gameSettings.players[i];
      final planetHex = sectorTable[sectors[i]]!.planetPosList[0];
      final planetCell = cells[hexTable[planetHex.toInt()]!];
      final planet = planetCell.planet!;
      planet.setHomePlanet(player.playerNumber);
    }
  }

  PlanetType _getRandPlanet(Random? random) {
    final rand = random ?? Random();

    final num = rand.nextInt(_weight);
    int sum = 0;
    for (final type in PlanetType.values) {
      if (type.weight == 0) {
        continue;
      }
      sum += type.weight;
      if (num <= sum) {
        return type;
      }
    }

    return PlanetType.terran;
  }

  int _getTotalWeight() {
    int sum = 0;
    for (final type in PlanetType.values) {
      sum += type.weight;
    }

    return sum;
  }

  void _prepareNames() {
    _names = List.from(planetNames);
    _names.shuffle(rand);
  }

  String _nextName() {
    if (_names.isNotEmpty) {
      return _names.removeLast();
    }

    final i = rand.nextInt(1444) + 42;

    return "Kepler-$i";
  }

  List<PlayerState> getTestPlayers(GameSettings gameSettings) {
    final humanPlayer = PlayerState(0, false)
      ..credit = gameSettings.playerStartingCredit.toDouble()
      ..empire = Empire.getEmpire("manchewark")
      ..color = Colors.blue;
    final testAI = PlayerState(1, true)
      ..credit = gameSettings.playerStartingCredit.toDouble()
      ..empire = Empire.getEmpire("uxbrid")
      ..color = Colors.red;

    return [humanPlayer, testAI];
  }
}
