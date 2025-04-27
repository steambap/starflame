import "ship_blueprint.dart";

enum Faction {
  neutral,
  terranTechnocracy,
  terranSeparatists,
  terranProtectorate,
  megaWar,
  soulHarvesters,
}

enum TradeRatio {
  twoToOne,
  threeToTwo,
}

class Empire {
  final Faction faction;
  final String displayName;
  final List<ShipBlueprint> blueprints;
  final TradeRatio tradeRatio;

  int supplyRange;

  Empire(this.faction, this.displayName, this.blueprints,
      {this.tradeRatio = TradeRatio.twoToOne, this.supplyRange = 2});

  static Empire getEmpire(Faction name) {
    assert(empireTable.containsKey(name), "Empire $name not found");
    return empireTable[name]!;
  }
}

final Map<Faction, Empire> empireTable = {
  Faction.neutral: Empire(Faction.neutral, "Neutral", []),
  Faction.terranTechnocracy: Empire(
      Faction.terranTechnocracy,
      "Terran Technocracy",
      [
        ShipBlueprint.corvette(
            name: "Corvette", image: "ships/corvette.png", totalFrames: 4),
        ShipBlueprint.destroyer(
            name: "Destroyer", image: "ships/destroyer.png", totalFrames: 4),
        ShipBlueprint.dreadnought(
            name: 'Dreadnought',
            image: "ships/dreadnought.png",
            totalFrames: 4),
      ],
      tradeRatio: TradeRatio.threeToTwo),
  Faction.terranSeparatists: Empire(
      Faction.terranSeparatists,
      "Terran Separatists",
      [
        ShipBlueprint.corvette(),
        ShipBlueprint.destroyer(),
        ShipBlueprint.dreadnought(active: false),
      ],
      tradeRatio: TradeRatio.threeToTwo),
  Faction.megaWar: Empire(Faction.megaWar, "Mega War Combine", [
    ShipBlueprint.corvette(),
    ShipBlueprint.destroyer(),
    ShipBlueprint.dreadnought(active: false),
  ]),
};
