import 'package:flutter/material.dart' show Color, Colors;
import "package:flutter/foundation.dart" show ChangeNotifier;

import "resource.dart";

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

  PlayerState(this.playerNumber, this.isAI);

  void addResource(Resources resource) {
    production += resource.production;
    credit += resource.credit;
    influence = resource.influence;
    
    notifyListeners();
  }
}
