import 'dart:ui';

import "resource_controller.dart";

class PlayerState {
  final int playerNumber;
  Color color = const Color(0x00000000);
  int race = 0;
  bool isAlive = true;
  final bool isCPU;
  double energy = 0;
  int techPoint = 0;
  int age = 0;

  PlayerState(this.playerNumber, this.isCPU);

  produceResource(ResourceController r) {
    final income = r.getPlayerIncome(playerNumber);
    addResource("energy", income.energy);
    techPoint = income.techPoint;

    // TODO statistics and inflation
  }

  addResource(String t, double amount) {
    if (t == "energy") {
      energy += amount;
    }
  }
}
