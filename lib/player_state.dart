import 'package:flutter/material.dart' show Color, Colors;
import "package:flutter/foundation.dart" show ChangeNotifier;

import "resource.dart";
import "sector.dart";
import "ship_template.dart";
import "ship_hull.dart";
import "ship_item.dart";
import "empire.dart";

class PlayerState with ChangeNotifier {
  static const double foodMax = 50;

  final int playerNumber;
  Color color = Colors.black;
  late final Empire empire;
  int team = -1;
  bool isAlive = true;
  final bool isAI;
  // Resources
  int production = 0;
  double credit = 0.0;
  int science = 0;
  int influence = 0;
  double food = 0;
  int citizenIdle = 0;
  int citizenInTransport = 0;
  int citizenOnPlanet = 0;
  bool citizenBoost = false;
  SectorDataTable sectorDataTable = const {};
  final List<ShipHull> hulls = [];
  final List<ShipItem> shipItems = [];
  final List<ShipTemplate> templates = [];

  PlayerState(this.playerNumber, this.isAI);

  int citizenTotal() {
    return citizenIdle + citizenInTransport + citizenOnPlanet;
  }

  void init() {
    citizenIdle = 2;
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
    sectorDataTable = capacity.sectorDataTable;
    citizenOnPlanet += capacity.citizen;

    notifyListeners();
  }

  void addCapacityAndResource(Capacity capacity, Resources resource) {
    addCapacity(capacity);
    addResource(resource);
  }

  void runProduction() {
    citizenIdle += citizenInTransport.clamp(0, 10);
    citizenInTransport = 0;

    food -= citizenTotal().toDouble();
    if (food >= foodMax) {
      final num = (food / foodMax).floor();
      citizenIdle += num;
      food -= num * foodMax;
    }

    food = food.clamp(-foodMax, foodMax);
  }
}
