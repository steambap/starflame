import 'dart:ui' show Paint, PaintingStyle;

import 'package:flutter/material.dart' show Color, Colors;
import "package:flutter/foundation.dart" show ChangeNotifier;

import "resource.dart";
import "ship_blueprint.dart";
import "empire.dart";
import "hex.dart";
import "sim_props.dart";

class PlayerState with ChangeNotifier, SimObject {
  final int playerNumber;
  late final Empire empire;
  int team = -1;
  bool isAlive = true;
  final bool isAI;
  // Resources
  int energy = 0;
  int production = 0;
  int politics = 0;

  int productionLimit = 50;

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
    production = productionLimit;
    refreshStatus();
  }

  void addResource(Resources resource) {
    energy += resource.energy;
    production += resource.production;
    production = production.clamp(0, productionLimit);
    politics += resource.politics;

    notifyListeners();
  }

  void takeAction(Resources res) {
    addResource(res);
  }

  void onNewTurn(Resources res) {
    addResource(res);
  }

  void refreshStatus() {
    notifyListeners();
  }
}
