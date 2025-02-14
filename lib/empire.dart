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
    ShipBlueprint.interceptor(
        name: "Destroyer", image: "ships/orange_destroyer.png", totalFrames: 4),
    ShipBlueprint.cruiser(
        name: "Cruiser", image: "ships/orange_cruiser.png", totalFrames: 4),
    ShipBlueprint.dreadnought(
        name: 'Dreadnought',
        active: false,
        image: "ships/orange_dreadnought.png",
        totalFrames: 4),
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
