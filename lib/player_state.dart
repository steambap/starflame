import 'package:flutter/material.dart' show Color, Colors;
import "package:flutter/foundation.dart" show ChangeNotifier;

import "resource.dart";
import "sector.dart";
import "ship_hull.dart";
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
  double production = 0;
  double credit = 0.0;
  double science = 0;
  double food = 0;
  SectorDataTable sectorDataTable = const {};
  final List<ShipHull> hulls = [];

  PlayerState(this.playerNumber, this.isAI);

  void init() {
    hulls.addAll(empire.startingHulls);
  }

  void addResource(Resources resource) {
    food += resource.maintaince;
    production += resource.production;
    credit += resource.credit;
    science += resource.science;

    notifyListeners();
  }

  void addCapacity(Capacity capacity) {
    sectorDataTable = capacity.sectorDataTable;

    notifyListeners();
  }

  void addCapacityAndResource(Capacity capacity, Resources resource) {
    addCapacity(capacity);
    addResource(resource);
  }

  void runProduction() {
    if (food >= foodMax) {
      final num = (food / foodMax).floor();
      food -= num * foodMax;
    }

    food = food.clamp(-foodMax, foodMax);
  }
}
