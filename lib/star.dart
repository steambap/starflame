import 'dart:math';

import 'planet.dart';
import "data/name.dart";

enum StarType {
  binary,
  none,
  blue,
  yellow,
  white,
  red,
}

class StarAndPlanets {
  final StarType starType;
  final List<Planet> planets;

  StarAndPlanets(this.starType, this.planets);
}

class StarGenerationHelper {
  static const Map<StarType, int> weightTable = {
    StarType.binary: 2,
    StarType.none: 1,
    StarType.blue: 10,
    StarType.yellow: 4,
    StarType.white: 10,
    StarType.red: 9,
  };
  static const Map<PlanetType, int> binaryWeightTable = {
    PlanetType.iron: 2,
    PlanetType.desert: 3,
    PlanetType.gas: 3,
  };
  static const Map<PlanetType, int> blueWeightTable = {
    PlanetType.terran: 1,
    PlanetType.iron: 2,
    PlanetType.desert: 3,
    PlanetType.ice: 4,
    PlanetType.gas: 1,
  };
  static const Map<PlanetType, int> yellowWeightTable = {
    PlanetType.terran: 1,
    PlanetType.iron: 1,
    PlanetType.desert: 2,
    PlanetType.ice: 2,
    PlanetType.gas: 2,
  };
  static const Map<PlanetType, int> whiteWeightTable = {
    PlanetType.terran: 1,
    PlanetType.iron: 2,
    PlanetType.desert: 4,
    PlanetType.ice: 3,
    PlanetType.gas: 1,
  };
  static const Map<PlanetType, int> redWeightTable = {
    PlanetType.iron: 1,
    PlanetType.desert: 4,
    PlanetType.ice: 3,
    PlanetType.gas: 1,
  };

  late final int _starWeight = weightTable.values.fold(0, (a, b) => a + b);
  late final int _binaryWeight =
      binaryWeightTable.values.fold(0, (a, b) => a + b);
  late final int _blueWeight = blueWeightTable.values.fold(0, (a, b) => a + b);
  late final int _yellowWeight =
      yellowWeightTable.values.fold(0, (a, b) => a + b);
  late final int _whiteWeight =
      whiteWeightTable.values.fold(0, (a, b) => a + b);
  late final int _redWeight = redWeightTable.values.fold(0, (a, b) => a + b);

  List<String> _noneNames = [];
  List<String> _binaryNames = [];
  List<String> _sysNames = [];
  List<String> _yellowNames = [];
  List<String> _redNames = [];

  StarType getRandStar(Random? random) {
    final rand = random ?? Random();

    final num = rand.nextInt(_starWeight);
    int sum = 0;
    for (final entry in weightTable.entries) {
      sum += entry.value;
      if (num <= sum) {
        return entry.key;
      }
    }

    return StarType.none;
  }

  List<Planet> _randPlanetsForBinary(Random random) {
    final planets = <Planet>[];
    final num = random.nextInt(_binaryWeight);
    int sum = 0;
    for (final entry in binaryWeightTable.entries) {
      sum += entry.value;
      if (num <= sum) {
        planets.add(Planet.of(entry.key));
      }
    }

    return planets;
  }

  List<Planet> _randPlanetsForBlue(Random random) {
    final planets = <Planet>[];
    final num = random.nextInt(_blueWeight);
    int sum = 0;
    for (final entry in blueWeightTable.entries) {
      sum += entry.value;
      if (num <= sum) {
        planets.add(Planet.of(entry.key));
      }
    }

    return planets;
  }

  List<Planet> _randPlanetsForYellow(Random random) {
    final planets = <Planet>[];
    final num = random.nextInt(_yellowWeight);
    int sum = 0;
    for (final entry in yellowWeightTable.entries) {
      sum += entry.value;
      if (num <= sum) {
        planets.add(Planet.of(entry.key));
      }
    }

    return planets;
  }

  List<Planet> _randPlanetsForWhite(Random random) {
    final planets = <Planet>[];
    final num = random.nextInt(_whiteWeight);
    int sum = 0;
    for (final entry in whiteWeightTable.entries) {
      sum += entry.value;
      if (num <= sum) {
        planets.add(Planet.of(entry.key));
      }
    }

    return planets;
  }

  List<Planet> _randPlanetsForRed(Random random) {
    final planets = <Planet>[];
    final num = random.nextInt(_redWeight);
    int sum = 0;
    for (final entry in redWeightTable.entries) {
      sum += entry.value;
      if (num <= sum) {
        planets.add(Planet.of(entry.key));
      }
    }

    return planets;
  }

  List<Planet> getRandPlanets(StarType star, Random? random) {
    final rand = random ?? Random();

    final planets = switch (star) {
      StarType.none => [Planet.gas(), Planet.gas()],
      StarType.binary => _randPlanetsForBinary(rand),
      StarType.blue => _randPlanetsForBlue(rand),
      StarType.yellow => _randPlanetsForYellow(rand),
      StarType.white => _randPlanetsForWhite(rand),
      StarType.red => _randPlanetsForRed(rand),
    };

    return planets;
  }

  StarAndPlanets generateStarAndPlanets(Random? random) {
    final star = getRandStar(random);
    final planets = getRandPlanets(star, random);

    return StarAndPlanets(star, planets);
  }

  void prepareNames(Random? random) {
    final rand = random ?? Random();

    _noneNames = List.from(noneNames)..shuffle(rand);
    _binaryNames = List.from(binaryNames)..shuffle(rand);
    _sysNames = List.from(sysNames)..shuffle(rand);
    _yellowNames = List.from(yellowNames)..shuffle(rand);
    _redNames = List.from(redNames)..shuffle(rand);
  }

  String _nextNoneName(Random rand) {
    if (_noneNames.isNotEmpty) {
      return _noneNames.removeLast();
    }

    final i = rand.nextInt(8964) + 1013;

    return "Void-$i";
  }

  String _nextBinaryName(Random rand) {
    if (_binaryNames.isNotEmpty) {
      return _binaryNames.removeLast();
    }

    final i = rand.nextInt(2233) + 42;

    return "Duo-$i";
  }

  String _nextSysName(Random rand) {
    if (_sysNames.isNotEmpty) {
      return _sysNames.removeLast();
    }

    final i = rand.nextInt(1013) + 42;

    return "Kepler-$i";
  }

  String _nextYellowName(Random rand) {
    if (_yellowNames.isNotEmpty) {
      return _yellowNames.removeLast();
    }

    final i = rand.nextInt(1125) + 28;

    return "Gaia-$i";
  }

  String _nextRedName(Random rand) {
    if (_redNames.isNotEmpty) {
      return _redNames.removeLast();
    }

    final i = rand.nextInt(1013) + 42;

    return "Alpha-$i";
  }

  String nextName(StarType star, Random? random) {
    final rand = random ?? Random();
    final result = switch (star) {
      StarType.none => _nextNoneName(rand),
      StarType.binary => _nextBinaryName(rand),
      StarType.blue => _nextSysName(rand),
      StarType.yellow => _nextYellowName(rand),
      StarType.white => _nextSysName(rand),
      StarType.red => _nextRedName(rand),
    };

    return result;
  }
}

final starGenerator = StarGenerationHelper();
