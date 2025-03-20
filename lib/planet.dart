import 'resource.dart';

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

  bool isColonized;
  String name;

  Planet(this.type,
      {this.isUnique = false, this.isColonized = false, this.name = ""});

  factory Planet.of(PlanetType type) {
    return switch (type) {
      PlanetType.terran => Planet(PlanetType.terran),
      PlanetType.desert => Planet(PlanetType.desert),
      PlanetType.iron => Planet(PlanetType.iron),
      PlanetType.ice => Planet(PlanetType.ice),
      PlanetType.gas => Planet(PlanetType.gas),
    };
  }

  static Resources getPlanetProps(PlanetType type) {
    return switch (type) {
      PlanetType.terran => const Resources(
          production: 7,
          credit: 7,
          science: 7,
        ),
      PlanetType.desert => const Resources(
          production: 3,
          credit: 5,
        ),
      PlanetType.iron => const Resources(
          production: 5,
        ),
      PlanetType.ice => const Resources(
          credit: 1,
          science: 5,
        ),
      PlanetType.gas => const Resources(
          production: 1,
          credit: 1,
          science: 1,
        ),
    };
  }
}
