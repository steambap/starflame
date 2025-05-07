import 'package:flutter/material.dart' show immutable;

import 'sim_props.dart';
import 'action_type.dart';

enum ShipType {
  corvette,
  destroyer,
  dreadnought,
  carrier,
  starbase,
}

@immutable
class ShipPart with SimObject {
  final String name;

  ShipPart(this.name, Map<Property, int> obj) {
    props.addAll(obj);
  }

  factory ShipPart.none() {
    return ShipPart("None", const {});
  }
}

class ShipBlueprint with SimObject {
  final ShipType type;
  final int cost;
  final String image;
  final List<ShipPart> parts;
  final int totalFrames;

  late String className;
  bool active;
  bool buildable;
  bool hasUpdated = false;
  bool freeUpdate = false;

  ShipBlueprint({
    required this.type,
    required this.cost,
    required this.image,
    required this.parts,
    required this.totalFrames,
    required Map<Property, int> obj,
    required String name,
    this.active = true,
    this.buildable = true,
  }) {
    props.addAll(obj);
    className = name.isNotEmpty ? name : type.name;
  }

  int maxHealth() {
    int ret = getProp(SimProps.maxHealth);
    for (final part in parts) {
      ret += part.getProp(SimProps.maxHealth);
    }

    return ret;
  }

  int maxMorale() {
    int ret = getProp(SimProps.maxMorale);
    for (final part in parts) {
      ret += part.getProp(SimProps.maxMorale);
    }

    return ret;
  }

  int movement() {
    int ret = getProp(SimProps.movement);
    for (final part in parts) {
      ret += part.getProp(SimProps.movement);
    }

    return ret;
  }

  int energyUpkeep() {
    int ret = getProp(SimProps.energyUpkeep);
    for (final part in parts) {
      ret += part.getProp(SimProps.energyUpkeep);
    }

    return ret;
  }

  int strength() {
    int ret = getProp(SimProps.strength);
    for (final part in parts) {
      ret += part.getProp(SimProps.strength);
    }

    return ret;
  }

  int rangedStrength() {
    if (getProp(SimProps.allowRanged) == 0) {
      return 0;
    }
    int str = strength();
    int ret = getProp(SimProps.rangedStrength);
    for (final part in parts) {
      ret += part.getProp(SimProps.rangedStrength);
    }

    return str + ret;
  }

  int attackRange() {
    if (getProp(SimProps.allowRanged) == 0) {
      return 1;
    } else {
      return 2;
    }
  }

  Iterable<ActionType> actionTypes() {
    final Set<ActionType> ret = {ActionType.selfRepair};

    return ret;
  }

  factory ShipBlueprint.corvette(
      {String name = "",
      bool active = true,
      String image = "ships/corvette.png",
      int totalFrames = 4}) {
    return ShipBlueprint(
        type: ShipType.corvette,
        cost: 3,
        name: name,
        image: image,
        obj: {
          SimProps.maxHealth: 150,
          SimProps.strength: 2,
          SimProps.movement: 30,
          SimProps.energyUpkeep: 1,
          SimProps.maxMorale: 3,
        },
        parts: [],
        totalFrames: totalFrames,
        active: active);
  }

  factory ShipBlueprint.destroyer(
      {String name = "",
      bool active = true,
      String image = "ships/destroyer.png",
      int totalFrames = 4}) {
    return ShipBlueprint(
        type: ShipType.destroyer,
        cost: 5,
        name: name,
        image: image,
        obj: {
          SimProps.maxHealth: 200,
          SimProps.strength: 3,
          SimProps.movement: 30,
          SimProps.energyUpkeep: 3,
          SimProps.maxMorale: 5,
        },
        parts: [],
        totalFrames: totalFrames,
        active: active);
  }

  factory ShipBlueprint.dreadnought(
      {String name = "",
      bool active = true,
      String image = "ships/dreadnought.png",
      int totalFrames = 4}) {
    return ShipBlueprint(
        type: ShipType.dreadnought,
        cost: 8,
        name: name,
        image: image,
        obj: {
          SimProps.maxHealth: 200,
          SimProps.strength: 4,
          SimProps.movement: 20,
          SimProps.energyUpkeep: 4,
          SimProps.maxMorale: 4,
        },
        parts: [],
        totalFrames: totalFrames,
        active: active);
  }
}
