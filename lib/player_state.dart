import 'dart:ui' show Paint, PaintingStyle;

import 'package:flutter/material.dart' show Color, Colors;
import "package:flutter/foundation.dart" show ChangeNotifier;

import "resource.dart";
import "ship_blueprint.dart";
import "empire.dart";
import "hex.dart";
import "sim_props.dart";

class PlayerState with ChangeNotifier, SimObject {
  static const double foodMax = 50;

  final int playerNumber;
  late final Empire empire;
  int team = -1;
  bool isAlive = true;
  final bool isAI;
  // Resources
  int energy = 0;
  int production = 0;
  int civic = 0;
  // Status
  int actionPoints = 4;
  int actionPointsMax = 4;
  final List<ShipBlueprint> blueprints = [];
  final Set<Hex> vision = {};

  PlayerState(this.playerNumber, this.isAI);

  List<Paint> paintLayer = [];
  Color _color = Colors.black;

  Color get color => _color;

  set color(Color value) {
    _color = value;
    paintLayer = [
      Paint()..color = value.withAlpha(128),
      Paint()
        ..color = value
        ..style = PaintingStyle.stroke,
    ];
  }

  void init() {
    blueprints.addAll(empire.blueprints);
    refreshStatus();
  }

  void addResource(Resources resource) {
    energy += resource.energy;
    production += resource.production;
    civic += resource.civic;

    notifyListeners();
  }

  bool canTakeAction() {
    return actionPoints > 0;
  }

  void takeAction(Resources res) {
    actionPoints -= 1;
    addResource(res);
  }

  void onNewTurn(Resources res) {
    actionPoints = actionPointsMax;
    addResource(res);
  }

  void refreshStatus() {
    notifyListeners();
  }
}
