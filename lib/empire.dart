import "ship_blueprint.dart";

enum Faction {
  neutral,
  terranEmpire,
  terranKindom,
  terranAlliance,
}

class Empire {
  final Faction faction;
  final String displayName;
  final List<ShipBlueprint> blueprints;

  Empire(this.faction, this.displayName, this.blueprints);

  static Empire getEmpire(String name) {
    assert(empireTable.containsKey(name), "Empire $name not found");
    return empireTable[name]!;
  }
}

final Map<String, Empire> empireTable = {
  "neutral": Empire(Faction.neutral, "Neutral", []),
  "terranEmpire": Empire(Faction.terranEmpire, "Terran Empire", [
    ShipBlueprint.interceptor(name: "Destroyer"),
    ShipBlueprint.cruiser(name: "Cruiser"),
    ShipBlueprint.dreadnought(name: 'Dreadnought', active: false),
  ]),
  "terranKindom": Empire(Faction.terranKindom, "Kindom of Terran", [
    ShipBlueprint.interceptor(),
    ShipBlueprint.cruiser(),
    ShipBlueprint.dreadnought(active: false),
  ]),
  "terranAlliance": Empire(Faction.terranAlliance, "Terran Alliance", [
    ShipBlueprint.interceptor(),
    ShipBlueprint.cruiser(),
    ShipBlueprint.dreadnought(active: false),
  ]),
};
