import "ship_type.dart";
import "scifi_game.dart";

class ResourceController {
  final ScifiGame game;

  ResourceController(this.game);

  void runProduction(int playerNumber) {
    for (final planet in game.mapGrid.planets) {
      if (planet.state.playerNumber == playerNumber) {
        planet.produceEnergy(playerNumber);
      }
    }
  }

  double humanPlayerEnergyIncome() {
    final idx = game.controller.getHumanPlayerNumber();
    double energy = 0.0;

    for (final planet in game.mapGrid.planets) {
      if (planet.state.playerNumber == idx) {
        energy += planet.energyIncome();
      }
    }

    return energy;
  }

  double getMaintaince(int playerNumber) {
    return 0;
  }

  double getShipCost(int playerNumber, ShipType type) {
    final data = game.shipData.table[type]!;
    final baseCost = data.cost.toDouble();

    return baseCost * 0.1;
  }
}
