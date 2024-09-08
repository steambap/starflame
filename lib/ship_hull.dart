import "action_type.dart";

enum ShipType {
  screen,
  capital,
  carrier,
  raider,
}

class ShipHull {
  static const maxHealth = 100;
  final int movement;
  final int strength;
  final ShipType type;
  final int cost;
  final String name;
  final String image;

  ShipHull({
    required this.movement,
    required this.strength,
    required this.type,
    required this.cost,
    required this.name,
    required this.image,
  });

  Iterable<ActionType> actionTypes() {
    final Set<ActionType> ret = {ActionType.selfRepair};

    return ret;
  }

  int attackRange() {
    return 1;
  }
}
