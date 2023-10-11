import "planet_type.dart";
import "building.dart";
import "installation.dart";

class PlanetState {
  PlanetType planetType;
  int? playerNumber;
  int population = 0;
  List<Building> buildings = [];
  List<Installation> installations = [];

  PlanetState(this.planetType);
}