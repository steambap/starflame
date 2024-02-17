import "planet_type.dart";

class Planet {
  PlanetType type;
  /// 0 = small, 1 = medium, 2 = large
  int size;
  bool colonized;

  Planet(this.type, {this.size = 1, this.colonized = false});

  setHome() {
    colonized = true;
    type = PlanetType.terran;
    size = 1;
  }
}
