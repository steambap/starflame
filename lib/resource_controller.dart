import "ship_type.dart";
import "scifi_game.dart";

class ResourceController {
  final ScifiGame game;

  ResourceController(this.game);

  void runProduction(int playerNumber) {
    for (final s in game.mapGrid.systems) {
      if (s.playerNumber == playerNumber) {
        s.produceEnergy(playerNumber);
      }
    }
  }

  double humanPlayerEnergyIncome() {
    final idx = game.controller.getHumanPlayerNumber();
    double energy = 0.0;

    for (final s in game.mapGrid.systems) {
      if (s.playerNumber == idx) {
        energy += s.energyIncome();
      }
    }

    return energy;
  }

  double humanPlayerMetalIncome() {
    final idx = game.controller.getHumanPlayerNumber();
    double metal = 0.0;

    for (final s in game.mapGrid.systems) {
      if (s.playerNumber == idx) {
        metal += s.metalIncome();
      }
    }

    return metal;
  }

  double getMaintaince(int playerNumber) {
    return 0;
  }

  double getShipCost(int playerNumber, ShipType type) {
    final data = game.shipData.table[type]!;
    final baseCost = data.cost.toDouble();

    return baseCost * 1.0;
  }
}
