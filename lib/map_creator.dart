import "dart:math";

import "hex.dart";
import "tile_type.dart";
import "game_creator.dart";
import "cell.dart";
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

class MapCreator {
  static const numOfSun = 7;
  static const minDistanceObj = 3;
  static const minDistanceToSun = 2;
  final GameCreator gameCreator;

  late final int _weight = _getTotalWeight();
  List<Cell> emptyCells = [];

  MapCreator(this.gameCreator);

  List<Cell> create() {
    final hexMap = generateHexMap(gameCreator.gameSettings.mapSize);

    int idx = 0;
    final cells = hexMap.map((Hex h) {
      final cell = Cell(idx, h);
      idx += 1;

      return cell;
    }).toList();
    emptyCells = List.from(cells);
    emptyCells.shuffle(gameCreator.rand);

    _tryCreateSun();
    _createPlanetAroundSun();
    _randomizePlanets();

    return cells;
  }

  _tryCreateSun() {
    int minDistance = 12;
    while (minDistance > 6) {
      final count = numOfSun - gameCreator.sunList.length;
      if (count <= 0) {
        break;
      }
      _createSun(minDistance, count);

      minDistance -= 2;
    }
    // clear empty tiles that contains sun
    for (final sunCell in gameCreator.sunList) {
      emptyCells.remove(sunCell);
    }
  }

  _createSun(int minDistance, int count) {
    loop:
    for (final cell in emptyCells) {
      // do not place sun at the edge
      if (cell.hex.distance(Hex.zero) > gameCreator.gameSettings.mapSize - 2) {
        continue loop;
      }
      // check existing sun
      for (final existing in gameCreator.sunList) {
        if (cell.hex.distance(existing.hex) < minDistance) {
          continue loop;
        }
      }
      // the cell is valid
      cell.tileType = TileType.sun;
      gameCreator.sunList.add(cell);
      gameCreator.planetList.add(cell);
      // check if we have enough
      count -= 1;
      if (count <= 0) {
        break loop;
      }
    }
  }

  _createPlanetAroundSun() {
    int distanceToSun = 4;
    while (distanceToSun < 8) {
      final count = numOfSun * 4 - gameCreator.planetList.length;
      if (count <= 0) {
        break;
      }
      _createPlanet(distanceToSun, count);

      distanceToSun += 1;
    }
  }

  _createPlanet(int distanceToSun, int numOfPlanet) {
    loop:
    for (final cell in emptyCells) {
      // check existing planet
      for (final existing in gameCreator.planetList) {
        final minDx = existing.tileType == TileType.sun
            ? minDistanceToSun
            : minDistanceObj;
        if (cell.hex.distance(existing.hex) < minDx) {
          continue loop;
        }
      }
      // check distance to sun
      bool valid = false;
      for (final sun in gameCreator.sunList) {
        if (cell.hex.distance(sun.hex) <= distanceToSun) {
          valid = true;
          break;
        }
      }
      if (!valid) {
        continue loop;
      }
      // the cell is valid
      final pType = _getRandPlanet(gameCreator.rand);
      cell.setPlanet(pType);
      gameCreator.planetList.add(cell);
      // check if we have enough
      numOfPlanet -= 1;
      if (numOfPlanet <= 0) {
        break loop;
      }
    }
  }

  _randomizePlanets() {
    for (final cell in gameCreator.planetList) {
      cell.planet?.state.size =
          PlanetSize.values[gameCreator.rand.nextInt(PlanetSize.values.length)];
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
}
