enum ActionType {
  buildColony,
  capture,
  stay,
  selfRepair,
}

class ActionState {
  final ActionType type;
  int cooldown = 0;

  ActionState(this.type);
}

enum ActionTarget {
  neutralPlanet,
  enemyPlanet,
  self,
}
