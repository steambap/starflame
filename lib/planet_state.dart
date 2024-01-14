import "planet_type.dart";
import "building.dart";
import "math.dart" show reverseFib;

class PlanetState {
  static const oneM = 1000000;

  PlanetType planetType;
  int? playerNumber;
  int population = 0;
  List<Building> buildings = [];
  PlanetSize size = PlanetSize.medium;

  PlanetState(this.planetType);

  int popLv() {
    return reverseFib(population ~/ oneM, 11);
  }
}
