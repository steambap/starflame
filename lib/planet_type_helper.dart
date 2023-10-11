import "dart:math";

import "planet_type.dart";

class PlanetTypeHelper {
  static const Map<PlanetType, int> weightTable = {
    PlanetType.ice: 4,
    PlanetType.swamp: 6,
    PlanetType.lava: 3,
    PlanetType.arid: 8,
    PlanetType.terran: 10,
  };
  static const Map<PlanetType, int> foodMap = {
    PlanetType.ice: 0,
    PlanetType.swamp: 2,
    PlanetType.lava: 0,
    PlanetType.arid: 1,
    PlanetType.terran: 3,
  };
  static const Map<PlanetType, int> energyMap = {
    PlanetType.ice: 0,
    PlanetType.swamp: 1,
    PlanetType.lava: 3,
    PlanetType.arid: 2,
    PlanetType.terran: 1,
  };

  late final int _weight = getTotalWeight();

  PlanetType getRandPlanet(Random? random) {
    final rand = random ?? Random();

    final num = rand.nextInt(_weight);
    int sum = 0;
    for (final entry in weightTable.entries) {
      sum += entry.value;
      if (num <= sum) {
        return entry.key;
      }
    }

    return PlanetType.terran;
  }

  int getTotalWeight() {
    int sum = 0;
    weightTable.forEach((key, value) {
      sum += value;
    });

    return sum;
  }
}
