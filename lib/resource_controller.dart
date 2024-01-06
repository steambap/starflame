import "building.dart";
import "planet_type.dart";
import "ship_type.dart";
import "scifi_game.dart";
import "planet.dart";
import "income.dart";

class ResourceController {
  final ScifiGame game;

  ResourceController(this.game);

  Income getPlayerIncome(int playerNumber) {
    double energy = 0;
    int tech = 0;

    for (final planet in game.mapGrid.planets) {
      if (planet.state.playerNumber == playerNumber) {
        final income = getPlanetIncome(planet);
        energy += income.energy;
        tech += income.techPoint;
      }
    }

    return Income.from(energy, tech);
  }

  Income getHumanPlayerIncome() {
    final i = game.controller.getHumanPlayerNumber();
    return getPlayerIncome(i);
  }

  Income getPlanetIncome(Planet planet) {
    final income = Income();
    double energyMultiplier = planet.state.planetType.energy.toDouble();
    for (final element in planet.state.buildings) {
      if (element == Building.techCenter) {
        income.techPoint += 1;
        if (planet.state.planetType == PlanetType.ice) {
          income.techPoint += 1;
        }
      }
      if (element == Building.galacticHQ) {
        energyMultiplier += 5;
      }
    }
    income.energy = planet.state.popLv() * energyMultiplier;

    return income;
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
