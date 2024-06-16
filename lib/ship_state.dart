import "action_type.dart";

class ShipState {
  late final int id;
  final int playerNumber;
  int exp = 0;
  int health = 1;
  String name = "";
  int movementUsed = 0;
  bool isTurnOver = false;
  bool attacked = false;
  final List<ActionState> actions = [];

  ShipState(this.playerNumber);
}
