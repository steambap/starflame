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
  static const Map<PlanetType, int> energyMap = {
    PlanetType.ice: 3,
    PlanetType.swamp: 4,
    PlanetType.lava: 7,
    PlanetType.arid: 6,
    PlanetType.terran: 5,
  };
  static const Map<PlanetType, int> growthRateMap = {
    PlanetType.ice: 0,
    PlanetType.swamp: 5,
    PlanetType.lava: 1,
    PlanetType.arid: 3,
    PlanetType.terran: 8,
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
