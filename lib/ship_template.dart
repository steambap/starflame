import "dart:math";

import "ship_hull.dart";
import "ship_item.dart";

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

  double cost() {
    return hull.cost + items.fold(0, (prev, item) => prev + item.cost);
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
      return hull.speedRange.x ~/ 10;
    }

    return hull.speedRange.y ~/ 10;
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
}
