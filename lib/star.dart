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

class PlanetAndStar {
  final PlanetType planetType;
  final StarType starType;

  PlanetAndStar(this.planetType, this.starType);
}

class StarGenerationHelper {
  static const Map<PlanetType, int> weightTable = {
    PlanetType.iron: 2,
    PlanetType.desert: 3,
    PlanetType.gas: 3,
    PlanetType.ice: 3,
    PlanetType.terran: 2,
  };

  static const Map<StarType, int> terranWeightTable = {
    StarType.blue: 2,
    StarType.yellow: 4,
    StarType.white: 2,
    StarType.red: 2,
  };

  static const Map<StarType, int> ironWeightTable = {
    StarType.blue: 3,
    StarType.yellow: 2,
    StarType.white: 3,
    StarType.red: 2,
  };

  static const Map<StarType, int> desertWeightTable = {
    StarType.binary: 2,
    StarType.blue: 2,
    StarType.yellow: 1,
    StarType.white: 2,
    StarType.red: 3,
  };
  static const Map<StarType, int> gasWeightTable = {
    StarType.none: 4,
    StarType.binary: 1,
    StarType.blue: 1,
    StarType.yellow: 2,
    StarType.white: 1,
    StarType.red: 1,
  };
  static const Map<StarType, int> iceWeightTable = {
    StarType.binary: 1,
    StarType.blue: 2,
    StarType.yellow: 2,
    StarType.white: 2,
    StarType.red: 3,
  };

  late final int _planetWeight = weightTable.values.fold(0, (a, b) => a + b);

  List<String> _noneNames = [];
  List<String> _binaryNames = [];
  List<String> _sysNames = [];
  List<String> _yellowNames = [];
  List<String> _redNames = [];

  StarType getRandStar(Random? random, Map<StarType, int> weightTable) {
    final rand = random ?? Random();

    final num = rand.nextInt(weightTable.values.fold(0, (a, b) => a + b));
    int sum = 0;
    for (final entry in weightTable.entries) {
      sum += entry.value;
      if (num <= sum) {
        return entry.key;
      }
    }

    return StarType.none;
  }

  PlanetType getRandPlanet(Random? random) {
    final rand = random ?? Random();

    final num = rand.nextInt(_planetWeight);
    int sum = 0;
    for (final entry in weightTable.entries) {
      sum += entry.value;
      if (num <= sum) {
        return entry.key;
      }
    }

    return PlanetType.iron;
  }

  PlanetAndStar generateStarAndPlanets(Random? random) {
    final planet = getRandPlanet(random);
    final star = getRandStar(random, getPlanetTable(planet));

    return PlanetAndStar(planet, star);
  }

  static Map<StarType, int> getPlanetTable(PlanetType planet) {
    return switch (planet) {
      PlanetType.iron => ironWeightTable,
      PlanetType.desert => desertWeightTable,
      PlanetType.gas => gasWeightTable,
      PlanetType.ice => iceWeightTable,
      PlanetType.terran => terranWeightTable,
    };
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
