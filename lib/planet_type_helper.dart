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
