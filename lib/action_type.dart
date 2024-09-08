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

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString(),
      'cooldown': cooldown,
    };
  }
}

enum ActionTarget {
  hex,
  self,
}
