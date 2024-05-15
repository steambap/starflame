import "dart:math";

import "ship_hull.dart";
import "ship_item.dart";
import "action.dart";
import "action_type.dart";

class ShipTemplate {
  String name = "";
  final ShipHull hull;
  List<ShipItem> items = [];

  ShipTemplate(
    this.hull,
  );

  ShipTemplate.define({
    required this.name,
    required this.hull,
    required this.items,
  });

  int cost() {
    return hull.cost;
  }

  int maxHealth() {
    int itemLife = 0;
    for (final item in items) {
      if (item is ShipUtil) {
        for (final skillVal in item.skills) {
          if (skillVal.skill == ShipItemSkill.life) {
            itemLife += skillVal.value;
          }
        }
      }
    }
    return hull.life + itemLife;
  }

  int itemMass() {
    return items.fold(0, (prev, item) => prev + item.mass);
  }

  int maxMove() {
    final mass = itemMass();

    final double percent = mass / hull.hullSize;

    if (percent > 0.8) {
      return hull.speedRange.x;
    }

    return hull.speedRange.y;
  }

  int maxRange() {
    int range = 0;
    for (final item in items) {
      if (item is ShipWeapon) {
        range = max(range, item.maxRange);
      }
    }

    return range;
  }

  int engineering() {
    int ret = 0;
    for (final item in items) {
      if (item is ShipUtil) {
        for (final skillVal in item.skills) {
          if (skillVal.skill == ShipItemSkill.engineering) {
            ret += skillVal.value;
          }
        }
      }
    }

    return ret;
  }

  int repairOnActionSelf() {
    int ret = 0;
    for (final item in items) {
      if (item is ShipUtil) {
        for (final skillVal in item.skills) {
          if (skillVal.skill == ShipItemSkill.repairOnActionSelf) {
            ret += skillVal.value;
          }
        }
      }
    }

    return ret;
  }

  List<ActionType> actionTypes() {
    final Set<ActionType> ret = {ActionType.stay};
    for (final item in items) {
      if (item is ShipWeapon) {
        ret.add(ActionType.capture);
      }
      if (item is ShipUtil) {
        for (final skillVal in item.skills) {
          if (skillVal.skill == ShipItemSkill.repairOnActionSelf) {
            ret.add(ActionType.selfRepair);
          } else if (skillVal.skill == ShipItemSkill.engineering) {
            ret.add(ActionType.buildColony);
          }
        }
      }
    }

    return ret.toList(growable: false);
  }

  List<Action> actions() {
    final ret = actionTypes();

    return ret.map((e) {
      assert(actionTable.containsKey(e), "Action ${e.name} not found in table");

      return actionTable[e]!;
    }).toList(growable: false);
  }

  List<ShipWeapon> weaponsInRange(int range) {
    return items
        .whereType<ShipWeapon>()
        .where((element) => element.maxRange >= range)
        .toList(growable: false);
  }
}
