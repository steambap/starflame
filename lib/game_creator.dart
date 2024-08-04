import "dart:math";
import "package:flutter/material.dart" show Colors;

// import "planet.dart";
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

class GameCreator {
  late GameSettings gameSettings;
  late Random rand;
  late final int _weight = _getTotalWeight();

  final List<Cell> cells = [];
  final List<Sector> sectors = [];
  final Set<Hex> homes = {};

  List<String> _names = [];

  void create(GameSettings gameSettings) {
    this.gameSettings = gameSettings;
    rand = Random(gameSettings.seed);

    cells.clear();
    sectors.clear();
    homes.clear();

    final hexList = generateHexMap(gameSettings.mapSize);

    final pPos = randPos(Hex(2, 0, -2));
    homes.addAll([pPos, Hex.zero - pPos]);

    for (int i = 0; i < hexList.length; i++) {
      final hex = hexList[i];
      final cell = Cell(i, hex);
      cells.add(cell);
      _createTile(cell);
    }

    _assignHomePlanet();

    _prepareNames();
    for (final s in sectors) {
      s.displayName = _nextName();
    }
  }

  int _createPlanets(Cell cell) {
    final size = rand.nextInt(3);

    final sector = Sector(cell.hex);
    sectors.add(sector);
    cell.sector = sector;
    // final s =
    //     Planet(_getRandPlanet(rand), cell.hex, cell.sector, planetSize: size);
    // cell.planet = s;
    // planets.add(s);

    return size + 3;
  }

  void _createTile(Cell cell) {
    if (homes.contains(cell.hex)) {
      return;
    }
    final num = rand.nextInt(4);

    if (num == 0) {
      _createPlanets(cell);
    } else if (num == 1) {
      cell.tileType = TileType.nebula;
    } else if (num == 2) {
      cell.tileType = TileType.gravityRift;
    } else {
      cell.tileType = TileType.asteroidField;
    }
  }

  _assignHomePlanet() {
    for (int i = 0; i < gameSettings.players.length; i++) {
      final player = gameSettings.players[i];
      final hex = homes.elementAt(i);
      final sector = Sector(hex);
      sectors.add(sector);
      sector.setHome(player.playerNumber);
      final cell = cells.firstWhere((c) => c.hex == hex);
      cell.sector = sector;
    }
  }

  Hex randPos(Hex h) {
    final rotation = rand.nextInt(5);

    final ret = switch (rotation) {
      1 => Hex(-h.s, -h.q, -h.r),
      2 => Hex(h.r, h.s, h.q),
      3 => Hex(-h.q, -h.r, -h.s),
      4 => Hex(h.s, h.q, h.r),
      5 => Hex(-h.r, -h.s, -h.q),
      _ => h,
    };

    return ret;
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
