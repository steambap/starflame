import "dart:collection";
import "dart:math";
import "package:flutter/material.dart" show Colors;

import "star_system.dart";
import "hex.dart";
import "cell.dart";
import "sector.dart";
import "game_settings.dart";
import "player_state.dart";
import "tile_type.dart";
import "planet.dart";
import "planet_type.dart";

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

const allNames = [
  "Proxima Centauri",
  "Lalande 21185",
  "Lacaille 9352",
  "YZ Ceti",
  "Gliese 1061",
  "Wolf 1061",
  "Wolf 1061",
  "Gliese 876",
  "82 G. Eridani",
  "Gliese 581",
  "HD 219134",
  "61 Virginis",
  "TRAPPIST-1",
  "55 Cancri",
  "HD 69830",
  "HD 40307",
  "Nu2 Lupi",
  "LHS 1140",
  "Mu Arae",
  "GJ 3929",
  "Pi Mensae",
  "HD 142",
  "K2-38",
  "TOI-1136",
  "HD 108236",
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
  final List<StarSystem> systems = [];
  final Map<Hex, Sector> sectorTable = {};
  Map<Hex, Hex> _lastFillMap = {};

  List<String> _names = [];

  void create(GameSettings gameSettings) {
    this.gameSettings = gameSettings;
    rand = Random(gameSettings.seed);

    cells.clear();
    hexList.clear();
    hexTable.clear();
    systems.clear();
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
    for (final s in systems) {
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
      if (!result.containsKey(value)) {
        result[value] = [];
      }
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
    // Spawn systems closer to center
    objects.sort((a, b) => a.distance(center).compareTo(b.distance(center)));

    int numOfPlanets = rand.nextInt(6) + 9;
    for (final hex in objects) {
      final idx = hexTable[hex.toInt()]!;
      final cell = cells[idx];
      if (numOfPlanets > 0) {
        numOfPlanets -= _createPlanets(cell);
        sectorTable[center]!.systemPosList.add(hex);
      } else {
        _createTile(cell);
      }
    }
    // Player should spawn further from galaxy center
    sectorTable[center]!
        .systemPosList
        .sort((a, b) => b.distance(Hex.zero).compareTo(a.distance(Hex.zero)));
  }

  int _createPlanets(Cell cell) {
    // 2 to 5 planets
    final int numOfPlanet = rand.nextInt(4) + 2;
    final List<Planet> planets = [];
    for (int i = 0; i < numOfPlanet; i++) {
      final size = rand.nextInt(3);
      final planet = Planet(_getRandPlanet(rand), size: size);
      planets.add(planet);
    }
    planets.sort((a, b) => b.type.growth.compareTo(a.type.growth));

    final s = StarSystem(planets, cell.hex);
    cell.system = s;
    systems.add(s);

    return planets.length;
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
      final systemHex = sectorTable[sectors[i]]!.systemPosList[0];
      final systemCell = cells[hexTable[systemHex.toInt()]!];
      final system = systemCell.system!;
      while (system.planets.length < 5) {
        system.planets.add(Planet(_getRandPlanet(rand), size: 1));
      }
      system.planets.sort((a, b) => b.type.growth.compareTo(a.type.growth));
      systemCell.system!.setHomePlanet(player.playerNumber);
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
    _names = List.from(allNames);
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
      ..energy = gameSettings.playerStartingEnergy.toDouble()
      ..color = Colors.blue;
    final testAI = PlayerState(1, true)
      ..energy = gameSettings.playerStartingEnergy.toDouble()
      ..race = 1
      ..color = Colors.red;

    return [humanPlayer, testAI];
  }
}
