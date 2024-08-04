import 'package:flutter/material.dart' show Color, Colors;
import "package:flutter/foundation.dart" show ChangeNotifier;

import "resource.dart";
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
  int production = 0;
  int credit = 0;
  int science = 0;
  final List<ShipHull> hulls = [];

  PlayerState(this.playerNumber, this.isAI);

  void init() {
    hulls.addAll(empire.startingHulls);
  }

  void addResource(Resources resource) {
    production += resource.production;
    credit += resource.credit;
    science += resource.science;

    notifyListeners();
  }
}
