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

  static Resources getPlanetProps(PlanetType type) {
    return switch (type) {
      PlanetType.terran => const Resources(
          production: 8,
          energy: 21,
        ),
      PlanetType.desert => const Resources(
          production: 5,
          energy: 13,
        ),
      PlanetType.iron => const Resources(
          production: 5,
        ),
      PlanetType.ice => const Resources(
          energy: 8,
        ),
      PlanetType.gas => const Resources(
          production: 5,
          energy: 8,
        ),
    };
  }
}
