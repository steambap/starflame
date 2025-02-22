import "ship_blueprint.dart";

enum Faction {
  neutral,
  terranTechnocracy,
  terranSeparatists,
  terranProtectorate,
  megaWar,
  soulHarvesters,
}

class Empire {
  final Faction faction;
  final String displayName;
  final List<ShipBlueprint> blueprints;

  Empire(this.faction, this.displayName, this.blueprints);

  static Empire getEmpire(Faction name) {
    assert(empireTable.containsKey(name), "Empire $name not found");
    return empireTable[name]!;
  }
}

final Map<Faction, Empire> empireTable = {
  Faction.neutral: Empire(Faction.neutral, "Neutral", []),
  Faction.terranTechnocracy:
      Empire(Faction.terranTechnocracy, "Terran Technocracy", [
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
  Faction.terranSeparatists:
      Empire(Faction.terranSeparatists, "Terran Separatists", [
    ShipBlueprint.interceptor(),
    ShipBlueprint.cruiser(),
    ShipBlueprint.dreadnought(active: false),
  ]),
  Faction.megaWar: Empire(Faction.megaWar, "Mega War Combine", [
    ShipBlueprint.interceptor(),
    ShipBlueprint.cruiser(),
    ShipBlueprint.dreadnought(active: false),
  ]),
};
