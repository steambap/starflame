enum PlanetType {
  habitable,
  inhabitable,
}

class Planet {
  final PlanetType type;
  final bool isUnique;
  bool isColonized = false;
  final int variant;

  String name;

  Planet(this.type, this.variant, {this.isUnique = false, this.name = ""});

  factory Planet.of(PlanetType type, int variant) {
    return switch (type) {
      PlanetType.habitable => Planet(type, variant),
      PlanetType.inhabitable => Planet(type, variant),
    };
  }
}
