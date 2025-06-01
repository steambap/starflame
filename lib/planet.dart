enum PlanetType {
  terran,
  desert,
  iron,
  ice,
  gas,
}

class Planet {
  final PlanetType type;
  final bool isUnique;

  String name;

  Planet(this.type, {this.isUnique = false, this.name = ""});

  factory Planet.of(PlanetType type) {
    return switch (type) {
      PlanetType.terran => Planet(PlanetType.terran),
      PlanetType.desert => Planet(PlanetType.desert),
      PlanetType.iron => Planet(PlanetType.iron),
      PlanetType.ice => Planet(PlanetType.ice),
      PlanetType.gas => Planet(PlanetType.gas),
    };
  }
}
