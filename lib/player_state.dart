import 'package:flutter/material.dart' show Color, Colors;
import "package:flutter/foundation.dart" show ChangeNotifier;

import "resource.dart";
import "sector.dart";
import "ship_template.dart";
import "ship_hull.dart";
import "ship_item.dart";
import "empire.dart";

class PlayerState with ChangeNotifier {
  final int playerNumber;
  Color color = Colors.black;
  late final Empire empire;
  int team = -1;
  bool isAlive = true;
  final bool isAI;
  // Resources
  int production = 0;
  double credit = 0.0;
  int influence = 0;
  SectorDataTable sectorDataTable = const {};
  final List<ShipHull> hulls = [];
  final List<ShipItem> shipItems = [];
  final List<ShipTemplate> templates = [];

  PlayerState(this.playerNumber, this.isAI);

  void init() {
    hulls.addAll(empire.starterHull());
    shipItems.addAll(empire.starterItems());
    templates.addAll(empire.starterTemplate());
  }

  void addResource(Resources resource) {
    production += resource.production;
    credit += resource.credit;

    notifyListeners();
  }

  void addCapacity(Capacity capacity) {
    influence = capacity.influence;
    sectorDataTable = capacity.sectorDataTable;

    notifyListeners();
  }

  void addCapacityAndResource(Capacity capacity, Resources resource) {
    addCapacity(capacity);
    addResource(resource);
  }
}
