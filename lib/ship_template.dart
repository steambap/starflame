import "dart:math";

import "ship_hull.dart";
import "ship_item.dart";
import "action.dart";
import "action_type.dart";
import "data/items.dart";

class ShipTemplate {
  final ShipHull hull;
  List<ShipSlot> _slotOverrides = [];
  List<ShipItem> upgrades = [];
  // Ship Item Cache
  final List<ShipItem> items = [];

  ShipTemplate(
    this.hull,
  ) {
    slot = hull.slots.map((slot) => ShipSlot(index: slot.index));
  }

  List<ShipSlot> get slot => _slotOverrides;
  set slot(Iterable<ShipSlot> value) {
    _slotOverrides = value.toList();
    items.clear();
    for (int i = 0; i < hull.slots.length; i++) {
      final defaultItem = hull.slots[i];
      final override = _slotOverrides[i];
      final itemName = override.itemName.isNotEmpty
          ? override.itemName
          : defaultItem.itemName;
      if (itemName.isNotEmpty) {
        items.add(shipItemMap[itemName]!);
      }
    }
  }

  String get name => hull.name;

  int cost() {
    int ret = hull.cost;
    for (final item in items) {
      ret += item.cost;
    }

    return ret;
  }

  int maxHealth() {
    int itemLife = 0;
    for (final item in items) {
      for (final skillVal in item.skills) {
        if (skillVal.skill == ShipItemSkill.life) {
          itemLife += skillVal.value;
        }
      }
    }
    return hull.life + itemLife;
  }

  int energyCost() {
    int ret = 0;
    for (final item in items) {
      if (item.energy < 0) {
        ret += item.energy;
      }
    }

    return ret.abs();
  }

  int energyProd() {
    int ret = 0;
    for (final item in items) {
      if (item.energy > 0) {
        ret += item.energy;
      }
    }

    return ret;
  }

  int maxMove() {
    final double percent = energyCost() / energyProd();

    if (percent > 0.8) {
      return hull.speedRange.x;
    }

    return hull.speedRange.y;
  }

  int maxRange() {
    int range = 0;
    for (final item in items) {
      if (item.isWeapon()) {
        range = max(range, item.weaponData!.damageAtRange.length);
      }
    }

    return range;
  }

  int repairOnActionSelf() {
    int ret = 0;
    for (final item in items) {
      for (final skillVal in item.skills) {
        if (skillVal.skill == ShipItemSkill.repairOnActionSelf) {
          ret += skillVal.value;
        }
      }
    }

    return ret;
  }

  Iterable<ActionType> actionTypes() {
    final Set<ActionType> ret = {ActionType.stay};
    for (final item in items) {
      for (final skillVal in item.skills) {
        if (skillVal.skill == ShipItemSkill.repairOnActionSelf) {
          ret.add(ActionType.selfRepair);
        }
      }
    }

    return ret;
  }

  List<Action> actions() {
    final ret = actionTypes();

    return ret.map((e) {
      assert(actionTable.containsKey(e), "Action ${e.name} not found in table");

      return actionTable[e]!;
    }).toList(growable: false);
  }

  Iterable<ShipItem> weaponsInRange(int range) {
    return items
        .where((element) => element.isWeapon())
        .where((weapon) => weapon.weaponData!.damageAtRange.length >= range);
  }
}
