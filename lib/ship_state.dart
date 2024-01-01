import "ship_type.dart";

class ShipState {
  late final int id;
  final ShipType type;
  final int playerNumber;
  int exp = 0;
  int health = 1;
  int moral = 1;
  String name = "";
  int movementUsed = 0;
  bool isTurnOver = false;
  bool attacked = false;

  ShipState(this.type, this.playerNumber);
}
