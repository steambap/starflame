import 'dart:ui' show Paint, PaintingStyle;

import 'package:flutter/material.dart' show Color, Colors;
import "package:flutter/foundation.dart" show ChangeNotifier;
import "package:starflame/data/tech.dart";

import "resource.dart";
import "ship_blueprint.dart";
import "empire.dart";
import "hex.dart";
import "sim_props.dart";
import "research.dart";
import "planet.dart";

class PlayerState with ChangeNotifier, SimObject {
  static const double foodMax = 50;

  final int playerNumber;
  late final Empire empire;
  int team = -1;
  bool isAlive = true;
  final bool isAI;
  // Resources
  int production = 0;
  int credit = 0;
  int science = 0;
  // Status
  int actionPoints = 4;
  int actionPointsMax = 4;
  final List<ShipBlueprint> blueprints = [];
  final Set<Hex> vision = {};
  final Set<PlanetType> colonizable = {
    PlanetType.terran,
  };
  final Map<TechSection, int> techLevel = {
    TechSection.military: 0,
    TechSection.science: 0,
    TechSection.industry: 0,
    TechSection.trade: 0,
    TechSection.empire: 0,
  };

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
    production += resource.production;
    credit += resource.credit;
    science += resource.science;

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

  void addTech(TechSection sec, int tier) {
    techLevel.update(sec, (prev) => tier, ifAbsent: () => tier);
    if (techTable[sec]?.containsKey(tier) ?? false) {
      techTable[sec]![tier]!.applyBenefit(this);
    }

    notifyListeners();
  }
}
