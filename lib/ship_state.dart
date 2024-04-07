class ShipState {
  late final int id;
  final int playerNumber;
  int exp = 0;
  int health = 1;
  int moral = 1;
  String name = "";
  int movementUsed = 0;
  bool isTurnOver = false;
  bool attacked = false;

  ShipState(this.playerNumber);
}
