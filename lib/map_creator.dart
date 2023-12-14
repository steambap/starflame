import "hex.dart";
import "tile_type.dart";
import "game_creator.dart";
import "hex_helper.dart" show generateHexMap;
import "cell.dart";
import "planet_type_helper.dart";

class MapCreator {
  static const numOfSun = 7;
  static const minDistanceObj = 3;
  static const minDistanceToSun = 2;
  final GameCreator gameCreator;
  final PlanetTypeHelper planetTypeHelper = PlanetTypeHelper();
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
      final pType = planetTypeHelper.getRandPlanet(gameCreator.rand);
      cell.setPlanet(pType);
      gameCreator.planetList.add(cell);
      // check if we have enough
      numOfPlanet -= 1;
      if (numOfPlanet <= 0) {
        break loop;
      }
    }
  }
}
