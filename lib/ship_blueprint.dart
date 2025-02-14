import 'package:flutter/material.dart' show immutable;

import 'sim_props.dart';
import 'action_type.dart';

enum ShipType {
  interceptor,
  cruiser,
  dreadnought,
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
    int ret = getProp(SimProps.hull);
    for (final part in parts) {
      ret += part.getProp(SimProps.hull);
    }

    return ret;
  }

  int movement() {
    int ret = getProp(SimProps.movement);
    for (final part in parts) {
      final mov = part.getProp(SimProps.movement);
      if (mov > 0) {
        ret = mov;
        break;
      }
    }

    return ret;
  }

  int energy() {
    int ret = getProp(SimProps.energy);
    for (final part in parts) {
      ret += part.getProp(SimProps.energy);
    }

    return ret;
  }

  int initiative() {
    int ret = getProp(SimProps.initiative);
    for (final part in parts) {
      ret += part.getProp(SimProps.initiative);
    }

    return ret;
  }

  int computers() {
    int ret = getProp(SimProps.computers);
    for (final part in parts) {
      ret += part.getProp(SimProps.computers);
    }

    return ret;
  }

  int countermeasures() {
    int ret = getProp(SimProps.countermeasures);
    for (final part in parts) {
      ret += part.getProp(SimProps.countermeasures);
    }

    return ret;
  }

  Iterable<int> cannons() {
    return parts
        .where((p) => p.getProp(SimProps.cannon) > 0)
        .map((p) => p.getProp(SimProps.cannon));
  }

  Iterable<int> missiles() {
    return parts
        .where((p) => p.getProp(SimProps.missile) > 0)
        .map((p) => p.getProp(SimProps.missile));
  }

  int attackRange() {
    final cannons = this.cannons();
    final missiles = this.missiles();

    if (missiles.isNotEmpty) {
      return 2;
    }

    if (cannons.isNotEmpty) {
      return 1;
    }

    return 1;
  }

  Iterable<ActionType> actionTypes() {
    final Set<ActionType> ret = {ActionType.selfRepair};

    return ret;
  }

  factory ShipBlueprint.interceptor(
      {String name = "",
      bool active = true,
      String image = "ships/raider.png",
      int totalFrames = 1}) {
    return ShipBlueprint(
        type: ShipType.interceptor,
        cost: 3,
        name: name,
        image: image,
        obj: {
          SimProps.hull: 12,
          SimProps.initiative: 2,
          SimProps.movement: 30,
          SimProps.energyUpkeep: 1,
        },
        parts: [
          ShipPart("Nuclear Source", const {
            SimProps.energy: 3,
          }),
          ShipPart("Ion Cannon", const {
            SimProps.cannon: 2,
            SimProps.energyUpkeep: 1,
          }),
          ShipPart.none(),
          ShipPart.none(),
        ],
        totalFrames: totalFrames,
        active: active);
  }

  factory ShipBlueprint.cruiser(
      {String name = "",
      bool active = true,
      String image = "ships/screen.png",
      int totalFrames = 1}) {
    return ShipBlueprint(
        type: ShipType.cruiser,
        cost: 5,
        name: name,
        image: image,
        obj: {
          SimProps.hull: 12,
          SimProps.initiative: 1,
          SimProps.movement: 30,
          SimProps.energyUpkeep: 1,
        },
        parts: [
          ShipPart("Nano Computer", const {
            SimProps.computers: 1,
          }),
          ShipPart("Nuclear Source", const {
            SimProps.energy: 3,
          }),
          ShipPart("Ion Cannon", const {
            SimProps.cannon: 2,
            SimProps.energyUpkeep: 1,
          }),
          ShipPart("Hull", const {
            SimProps.hull: 6,
          }),
          ShipPart.none(),
          ShipPart.none(),
        ],
        totalFrames: totalFrames,
        active: active);
  }

  factory ShipBlueprint.dreadnought(
      {String name = "",
      bool active = true,
      String image = "ships/capital.png",
      int totalFrames = 1}) {
    return ShipBlueprint(
        type: ShipType.dreadnought,
        cost: 8,
        name: name,
        image: "ships/capital.png",
        obj: {
          SimProps.hull: 12,
          SimProps.movement: 20,
          SimProps.energyUpkeep: 2,
        },
        parts: [
          ShipPart("Nano Computer", const {
            SimProps.computers: 1,
          }),
          ShipPart("Nuclear Source", const {
            SimProps.energy: 3,
          }),
          ShipPart("Ion Cannon", const {
            SimProps.cannon: 2,
            SimProps.energyUpkeep: 1,
          }),
          ShipPart("Hull", const {
            SimProps.hull: 6,
          }),
          ShipPart("Ion Cannon", const {
            SimProps.cannon: 2,
            SimProps.energyUpkeep: 1,
          }),
          ShipPart("Hull", const {
            SimProps.hull: 6,
          }),
          ShipPart.none(),
          ShipPart.none(),
        ],
        totalFrames: totalFrames,
        active: active);
  }
}
