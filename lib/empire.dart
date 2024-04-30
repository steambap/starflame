import "ship_item.dart";
import "ship_hull.dart";
import "ship_template.dart";
import "data/items.dart";
import "data/hulls.dart";

enum Faction {
  neutral,
  manchewark,
  uxbrid,
  barham,
}

/// TODO make empires customizable
class Empire {
  final Faction faction;
  final String displayName;
  final List<ShipItem> weapons;
  final List<ShipItem> utils;
  final List<ShipHull> hulls;

  Empire(this.faction, this.displayName, this.weapons, this.utils, this.hulls);

  static Empire getEmpire(String name) {
    assert(buildinEmpire.containsKey(name), "Empire $name not found");
    return buildinEmpire[name]!;
  }

  List<ShipHull> starterHull({int tier = 0}) {
    return hulls.where((element) => element.tier <= tier).toList();
  }

  List<ShipItem> starterItems({int tier = 0}) {
    return [...weapons, ...utils]
        .where((element) => element.tier <= tier)
        .toList();
  }

  List<ShipTemplate> starterTemplate() {
    final basicSupportShip =
        ShipTemplate.define(name: "patrol ship", hull: hulls[0], items: [
      weapons[0],
      weapons[0],
    ]);
    final basicCombatShip =
        ShipTemplate.define(name: "colony ship", hull: hulls[0], items: [
      utils[0],
      utils[0],
    ]);

    return [basicSupportShip, basicCombatShip];
  }
}

final Map<String, Empire> buildinEmpire = {
  "neutral": Empire(Faction.neutral, "Neutral", [], [], [hullMap["kraken"]!]),
  "manchewark": Empire(Faction.manchewark, "Manchewark Empire", [
    shipItemMap["Depleted Uranium Cannon"]!,
    shipItemMap["Heavy Rail Cannon"]!,
    shipItemMap["Flamer"]!,
    shipItemMap["Twin-Linked Rail Cannon"]!,
    shipItemMap["Plasma Gun"]!,
    shipItemMap["Pulse Laser"]!,
    shipItemMap["Fusion Blaster"]!,
  ], [
    shipItemMap["Engineering Kit 1"]!,
    shipItemMap["Nano Repair"]!,
    shipItemMap["Core Protector"]!,
    shipItemMap["Engineering Kit 2"]!,
    shipItemMap["Armor Plating"]!,
    shipItemMap["Reactive Armor"]!,
    shipItemMap["Engineering Kit 3"]!,
    shipItemMap["Advanced Hull Armor"]!,
  ], [
    hullMap["wolf"]!,
    hullMap["tiger"]!,
    hullMap["panther"]!,
    hullMap["kraken"]!,
    hullMap["lion"]!,
    hullMap["crocodile"]!,
    hullMap["spider"]!,
  ]),
  "uxbrid": Empire(Faction.uxbrid, "Uxbrid Empire", [
    shipItemMap["Depleted Uranium Cannon"]!,
    shipItemMap["Missle Launcher"]!,
    shipItemMap["Flamer"]!,
    shipItemMap["Twin-Linked Rail Cannon"]!,
    shipItemMap["Twin-Linked Missle Launcher"]!,
    shipItemMap["Pulse Laser"]!,
    shipItemMap["Rail Cannon Array"]!,
  ], [
    shipItemMap["Engineering Kit 1"]!,
    shipItemMap["Nano Repair"]!,
    shipItemMap["Core Protector"]!,
    shipItemMap["Engineering Kit 2"]!,
    shipItemMap["Armor Plating"]!,
    shipItemMap["Reactive Armor"]!,
    shipItemMap["Engineering Kit 3"]!,
    shipItemMap["Advanced Hull Armor"]!,
  ], [
    hullMap["mk-55"]!,
    hullMap["mk-89"]!,
    hullMap["ranger"]!,
    hullMap["kraken"]!,
    hullMap["mk-144"]!,
    hullMap["obsidian"]!,
  ]),
  "barham": Empire(Faction.barham, "Barham Empire", [
    shipItemMap["Depleted Uranium Cannon"]!,
    shipItemMap["Heavy Rail Cannon"]!,
    shipItemMap["Flamer"]!,
    shipItemMap["Missle Launcher"]!,
    shipItemMap["Plasma Gun"]!,
    shipItemMap["Ripper Beam"]!,
  ], [
    shipItemMap["Engineering Kit 1"]!,
    shipItemMap["Nano Repair"]!,
    shipItemMap["Core Protector"]!,
    shipItemMap["Engineering Kit 2"]!,
    shipItemMap["Armor Plating"]!,
    shipItemMap["Reactive Armor"]!,
    shipItemMap["Engineering Kit 3"]!,
    shipItemMap["Advanced Hull Armor"]!,
  ], [
    hullMap["grasshopper"]!,
    hullMap["mantis"]!,
    hullMap["raptor"]!,
    hullMap["griffin"]!,
    hullMap["pheonix"]!,
  ]),
};
