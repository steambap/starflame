import "ship_item.dart";
import "ship_hull.dart";
import "data/items.dart";
import "data/hulls.dart";

enum Faction {
  neutral,
  terranEmpire,
  terranKindom,
  terranAlliance,
}

class Empire {
  final Faction faction;
  final String displayName;
  final List<ShipItem> startingItems;
  final List<ShipHull> startingHulls;

  Empire(this.faction, this.displayName, this.startingItems, this.startingHulls);

  static Empire getEmpire(String name) {
    assert(buildinEmpire.containsKey(name), "Empire $name not found");
    return buildinEmpire[name]!;
  }
}

final Map<String, Empire> buildinEmpire = {
  "neutral": Empire(Faction.neutral, "Neutral", [], [hullMap["kraken"]!]),
  "terranEmpire": Empire(Faction.terranEmpire, "Terran Empire", [
    shipItemMap["Depleted Uranium Cannon"]!,
    shipItemMap["Heavy Rail Cannon"]!,
    shipItemMap["Nano Repair"]!,
  ], [
    hullMap["wolf"]!,
    hullMap["tiger"]!,
  ]),
  "terranKindom": Empire(Faction.terranKindom, "Kindom of Terran", [
    shipItemMap["Depleted Uranium Cannon"]!,
    shipItemMap["Flux Missle"]!,
    shipItemMap["Nano Repair"]!,
  ], [
    hullMap["mk-55"]!,
    hullMap["mk-89"]!,
  ]),
  "terranAlliance": Empire(Faction.terranAlliance, "Terran Alliance", [
    shipItemMap["Depleted Uranium Cannon"]!,
    shipItemMap["Heavy Rail Cannon"]!,
    shipItemMap["Nano Repair"]!,
  ], [
    hullMap["grasshopper"]!,
    hullMap["mantis"]!,
  ]),
};
