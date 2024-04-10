import 'package:flutter/material.dart' show Color, Colors;
import "package:flutter/foundation.dart" show ChangeNotifier;

import "resource.dart";
import "ship_template.dart";
import "data/hulls.dart";
import "data/items.dart";

class PlayerState with ChangeNotifier {
  final int playerNumber;
  Color color = Colors.black;
  int race = 0;
  int team = -1;
  bool isAlive = true;
  final bool isAI;
  // Resources
  int production = 0;
  double credit = 0.0;
  int influence = 0;
  final Set<String> hulls = {};
  final Set<String> shipItems = {};
  final List<ShipTemplate> templates = [];

  PlayerState(this.playerNumber, this.isAI, this.race);

  void init() {
    fillShipTemplates();
  }

  void fillShipTemplates() {
    hulls.addAll(["wolf"]);
    shipItems.addAll(["Depleted Uranium Cannon", "Engineering Kit 1"]);
    final basicSupportShip = ShipTemplate.define(
        name: "colony ship",
        hull: hullMap["wolf"]!,
        items: [
          shipItemMap["Engineering Kit 1"]!,
          shipItemMap["Engineering Kit 1"]!
        ]);
    final basicCombatShip = ShipTemplate.define(
        name: "patrol ship",
        hull: hullMap["wolf"]!,
        items: [
          shipItemMap["Depleted Uranium Cannon"]!,
          shipItemMap["Depleted Uranium Cannon"]!
        ]);
    templates.addAll([basicSupportShip, basicCombatShip]);
  }

  void addResource(Resources resource) {
    production += resource.production;
    credit += resource.credit;

    notifyListeners();
  }

  void addIncome(Income resource) {
    production += resource.production;
    credit += resource.credit;
    influence = resource.influence;

    notifyListeners();
  }
}
