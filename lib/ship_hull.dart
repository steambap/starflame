import "action.dart";
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
    final Set<ActionType> ret = {ActionType.stay, ActionType.selfRepair};

    return ret;
  }

  List<Action> actions() {
    final ret = actionTypes();

    return ret.map((e) {
      assert(actionTable.containsKey(e), "Action ${e.name} not found in table");

      return actionTable[e]!;
    }).toList(growable: false);
  }

  int attackRange() {
    return 1;
  }
}
