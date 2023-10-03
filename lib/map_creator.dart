import "hex.dart";
import "tile_type.dart";
import "game_creator.dart";
import "hex_helper.dart" show generateHexMap;
import "cell.dart";

class MapCreator {
  static const numOfPlanet = 18;
  final GameCreator gameCreator;

  MapCreator(this.gameCreator);

  List<Cell> create() {
    final hexMap = generateHexMap(9);
    final List<Cell> firstRing = List.empty(growable: true);
    final List<Cell> secondRing = List.empty(growable: true);
    final List<Cell> thirdRing = List.empty(growable: true);
    final List<Cell> cells = hexMap.map((Hex h) {
      final Cell cell = Cell(h);
      final distance = h.distance(Hex.zero);
      if (h == Hex.zero) {
        cell.tileType = TileType.gravityRift;
      } else if (distance <= 3) {
        firstRing.add(cell);
      } else if (distance <= 6) {
        secondRing.add(cell);
      } else {
        thirdRing.add(cell);
      }

      return cell;
    }).toList();
    firstRing.shuffle(gameCreator.rand);
    secondRing.shuffle(gameCreator.rand);
    thirdRing.shuffle(gameCreator.rand);
    for (int i = 0; i < numOfPlanet; i++) {
      final rIndex = gameCreator.rand.nextInt(3);
      final cell = switch (rIndex) {
        0 => firstRing.removeLast(),
        1 => secondRing.removeLast(),
        2 => thirdRing.removeLast(),
        _ => Cell(Hex.zero),
      };

      final pType =
          gameCreator.planetTypeHelper.getRandPlanet(gameCreator.rand);
      cell.setPlanet(pType);
    }

    // first ring asteroid
    _balanceTile(firstRing, 2, TileType.asteroidField);
    // second ring asteroid
    _balanceTile(secondRing, 4, TileType.asteroidField);
    // third ring asteroid
    _balanceTile(thirdRing, 6, TileType.asteroidField);

    _balanceTile(firstRing, 2, TileType.nebula);
    _balanceTile(secondRing, 4, TileType.nebula);
    _balanceTile(thirdRing, 6, TileType.nebula);

    _balanceTile(secondRing, 2, TileType.alphaWormHole);
    _balanceTile(thirdRing, 2, TileType.betaWormHole);

    return cells;
  }

  _balanceTile(List<Cell> cells, int num, TileType t) {
    int numLeft = num;
    while(cells.isNotEmpty && numLeft > 0) {
      final cell = cells.removeLast();
      cell.tileType = t;
      numLeft -= 1;
    }
  }
}
