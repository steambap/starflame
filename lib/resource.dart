import 'package:flutter/foundation.dart' show immutable;

// Resources that can be stockpiled
@immutable
class Resources {
  final int energy;
  final int production;
  final int civic;

  const Resources({this.energy = 0, this.production = 0, this.civic = 0});

  Resources operator +(Resources other) {
    return Resources(
      energy: energy + other.energy,
      production: production + other.production,
      civic: civic + other.civic,
    );
  }

  Resources operator *(int multiplier) {
    return Resources(
      energy: energy * multiplier,
      production: production * multiplier,
      civic: civic * multiplier,
    );
  }
}
