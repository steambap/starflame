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
    assert(buildinEmpire.containsKey(name), "Empire $name not found");
    return buildinEmpire[name]!;
  }
}

final Map<String, Empire> buildinEmpire = {
  "neutral": Empire(Faction.neutral, "Neutral", []),
  "terranEmpire": Empire(Faction.terranEmpire, "Terran Empire", [
    ShipBlueprint.interceptor(),
    ShipBlueprint.cruiser(),
  ]),
  "terranKindom": Empire(Faction.terranKindom, "Kindom of Terran", [
    ShipBlueprint.interceptor(),
    ShipBlueprint.cruiser(),
  ]),
  "terranAlliance": Empire(Faction.terranAlliance, "Terran Alliance", [
    ShipBlueprint.interceptor(),
    ShipBlueprint.cruiser(),
  ]),
};
