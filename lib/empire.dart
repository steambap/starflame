import "ship_hull.dart";
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
  final List<ShipHull> startingHulls;

  Empire(this.faction, this.displayName, this.startingHulls);

  static Empire getEmpire(String name) {
    assert(buildinEmpire.containsKey(name), "Empire $name not found");
    return buildinEmpire[name]!;
  }
}

final Map<String, Empire> buildinEmpire = {
  "neutral": Empire(Faction.neutral, "Neutral", [hullMap["Interceptor"]!]),
  "terranEmpire": Empire(Faction.terranEmpire, "Terran Empire", [
    hullMap["Interceptor"]!,
    hullMap["Cruiser"]!,
  ]),
  "terranKindom": Empire(Faction.terranKindom, "Kindom of Terran", [
    hullMap["Interceptor"]!,
    hullMap["Cruiser"]!,
  ]),
  "terranAlliance": Empire(Faction.terranAlliance, "Terran Alliance",[
    hullMap["Interceptor"]!,
    hullMap["Cruiser"]!,
  ]),
};
