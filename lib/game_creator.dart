import "dart:math";
import "hex.dart";
import "cell.dart";
import "game_settings.dart";
import "planet.dart";
import "tile_type.dart";

const goldenRatio = 1.6180339887498948482;

class GameCreator {
  late GameSettings gameSettings;
  late Random rand;

  final List<Cell> cells = [];

  /// Hex to cell index
  final Map<int, Cell> cellTable = {};
  final Set<int> centerCells = {};
  final List<Planet> planets = [];
  int planetIdx = 0;
  int playerHomeIdx = 0;
  // final List<Sector> sectors = [];
  // final List<Hex> homes = [];

  void create(GameSettings gameSettings) {
    this.gameSettings = gameSettings;
    rand = Random(gameSettings.seed);

    cells.clear();
    cellTable.clear();
    planets.clear();
    planetIdx = 0;
    playerHomeIdx = 0;

    _generateGalaticCenter();
    for (int i = 1; i <= gameSettings.mapSize; i++) {
      final hexes = Hex.zero.cubeRingN(i, gameSettings.sectorSize);
      switch (i) {
        case 1:
          _generateFirstRing(hexes);
          break;
        case 2:
          _generateSecondRing(hexes);
          break;
        case 3:
          _generateThirdRing(hexes);
          break;
        default:
          _generateOuterRing(hexes);
          break;
      }
    }
  }

  Cell _generateCell(Hex hex) {
    final cell = Cell(hex.toInt(), hex);
    cells.add(cell);
    cellTable[hex.toInt()] = cell;
    return cell;
  }

  void _generateGalaticCenter() {
    final clusterHexes = Hex.zero.cubeSpiral(gameSettings.sectorSize);

    for (final hex in clusterHexes) {
      _generateCell(hex);
    }

    _planetAtCell(Hex.zero, PlanetType.terran);
  }

  void _generateFirstRing(List<Hex> centers) {
    for (final center in centers) {
      final clusterHexes = center.cubeSpiral(gameSettings.sectorSize);

      for (final hex in clusterHexes) {
        _generateCell(hex);
      }

      _planetAtCell(center, PlanetType.exo);
    }
  }

  void _generateSecondRing(List<Hex> centers) {
    for (final center in centers) {
      final clusterHexes = center.cubeSpiral(gameSettings.sectorSize);

      final cells = <Cell>[];
      for (final hex in clusterHexes) {
        cells.add(_generateCell(hex));
      }

      final r = rand.nextDouble();
      if (r > 0.67) {
        for (final cell in cells) {
          cell.tileType = TileType.gravityRift;
        }
      } else {
        _planetAtCell(center, PlanetType.exo);
      }
    }
  }

  void _generateThirdRing(List<Hex> centers) {
    final playerHomeIndex = switch (gameSettings.players.length) {
      2 => _getStartIndex2P(),
      3 => _getStartIndex3P(),
      6 => _getStartIndex6P(),
      _ => _getStartIndexNP(gameSettings.players.length),
    };

    for (int i = 0; i < centers.length; i++) {
      final center = centers[i];
      final clusterHexes = center.cubeSpiral(gameSettings.sectorSize);

      final cells = <Cell>[];
      for (final hex in clusterHexes) {
        cells.add(_generateCell(hex));
      }

      if (playerHomeIndex.contains(i)) {
        _homePlanetAtCell(center);
        continue;
      }

      final r = rand.nextDouble();
      if (r >= 0.8) {
        for (final cell in cells) {
          cell.tileType = TileType.gravityRift;
        }
      } else if (r >= 0.6) {
        for (final cell in cells) {
          cell.tileType = TileType.nebula;
        }
      } else {
        _planetAtCell(center, PlanetType.arid);
      }
    }
  }

  void _generateOuterRing(List<Hex> centers) {
    for (final center in centers) {
      final clusterHexes = center.cubeSpiral(gameSettings.sectorSize);

      final cells = <Cell>[];
      for (final hex in clusterHexes) {
        _generateCell(hex);
      }

      final r = rand.nextDouble();
      if (r >= 0.8) {
        for (final cell in cells) {
          cell.tileType = TileType.gravityRift;
        }
      } else if (r >= 0.6) {
        for (final cell in cells) {
          cell.tileType = TileType.nebula;
        }
      } else if (r >= 0.2) {
        _planetAtCell(center, PlanetType.ice);
      }
    }
  }

  Planet _planetAtCell(Hex center, PlanetType type) {
    final centerCell = cellTable[center.toInt()]!;
    final planet = Planet(planetIdx, center, type);
    centerCell.planet = planet;
    planets.add(planet);
    planetIdx += 1;

    return planet;
  }

  Planet _homePlanetAtCell(Hex center) {
    final planet = _planetAtCell(center, PlanetType.terran);
    planet.setHome(playerHomeIdx);
    playerHomeIdx += 1;

    return planet;
  }

  List<int> _getStartIndex2P() {
    final r = rand.nextInt(18);
    final r2 = (r + 9) % 18;

    return [r, r2];
  }

  List<int> _getStartIndex3P() {
    final r = rand.nextInt(18);
    final r2 = (r + 6) % 18;
    final r3 = (r2 + 6) % 18;

    return [r, r2, r3];
  }

  List<int> _getStartIndex6P() {
    final r = rand.nextInt(18);
    final r2 = (r + 3) % 18;
    final r3 = (r2 + 3) % 18;
    final r4 = (r3 + 3) % 18;
    final r5 = (r4 + 3) % 18;
    final r6 = (r5 + 3) % 18;

    return [r, r2, r3, r4, r5, r6];
  }

  List<int> _getStartIndexNP(int n) {
    const a1 = 1.0 / goldenRatio;
    final pad = rand.nextDouble();
    final result = <int>[];

    for (int i = 0; i < n; i++) {
      final r = (a1 * i + pad) % 1;
      final index = (r * 18).floor();
      result.add(index);
    }

    return result;
  }
}
