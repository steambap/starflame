import "scifi_game.dart";
import "player_state.dart";
import "planet.dart";
import "cell.dart";
import "building.dart";
import "ship_template.dart";
import "resource.dart";
import "sector.dart";

class ResourceController {
  final ScifiGame game;

  ResourceController(this.game);

  void runProduction(int playerNumber) {
    final playerState = game.controller.getPlayerState(playerNumber);

    final capacity = scanCapacity(playerState);
    playerState.addCapacity(capacity);

    final income = playerIncome(playerState);
    playerState.addResource(income);
  }

  Resources playerIncome(PlayerState state) {
    Resources income = Resources();

    for (final planet in game.mapGrid.planets) {
      if (planet.playerNumber == state.playerNumber) {
        income += calcPlanetIncome(state, planet);
      }
    }

    return income;
  }

  Resources humanPlayerIncome() {
    final state = game.controller.getHumanPlayerState();

    return playerIncome(state);
  }

  Resources calcPlanetIncome(PlayerState playerState, Planet planet) {
    Resources income = Resources();

    for (final bd in planet.buildings) {
      if (bd == Building.colonyHQ) {
        income += Resources(production: 10, credit: 20);
      } else if (bd == Building.constructionYard) {
        income += Resources(production: 10);
      } else if (bd == Building.fusionReactor) {
        income += Resources(credit: 80);
      }
    }

    income.credit += planet.tax() + planet.tradeIncome();
    income.production += planet.type.production;

    return income;
  }

  Capacity scanCapacity(PlayerState playerState) {
    Capacity capacity = Capacity();

    for (final planet in game.mapGrid.planets) {
      if (planet.playerNumber == playerState.playerNumber) {
        capacity += calcPlanetCapacity(playerState, planet);
      }
    }

    return capacity;
  }

  Capacity calcPlanetCapacity(PlayerState playerState, Planet planet) {
    Capacity capacity = Capacity();
    final dataTable = capacity.sectorDataTable;
    dataTable.putIfAbsent(planet.sector, () => SectorData());
    if (planet.buildings.contains(Building.tradeCompany)) {
      dataTable[planet.sector]?.invest += 5;
    }
    for (final bd in planet.buildings) {
      if (bd == Building.mediaNetwork) {
        capacity.influence += 5;
      } else if (bd == Building.colonyHQ) {
        capacity.influence += 5;
      }
    }

    return capacity;
  }

  double getMaintaince(int playerNumber) {
    return 0;
  }

  bool canDevelopFood(int playerNumber, Planet planet) {
    final playerState = game.controller.getPlayerState(playerNumber);

    return playerState.production >= 8 && !planet.isFoodDeveloped();
  }

  bool developFood(int playerNumber, Planet planet) {
    final playerState = game.controller.getPlayerState(playerNumber);

    if (!canDevelopFood(playerNumber, planet)) {
      return false;
    }

    planet.developFood(playerNumber);
    playerState.addResource(Resources(production: -8));

    return true;
  }

  bool canInvestTrade(int playerNumber, Planet planet) {
    final playerState = game.controller.getPlayerState(playerNumber);

    return playerState.production >= 5;
  }

  bool investTrade(int playerNumber, Planet planet) {
    final playerState = game.controller.getPlayerState(playerNumber);

    if (!canInvestTrade(playerNumber, planet)) {
      return false;
    }

    planet.investTrade(playerNumber);
    playerState.addResource(Resources(production: -5));

    return true;
  }

  bool canUpgradePlanet(int playerNumber, Planet planet) {
    final playerState = game.controller.getPlayerState(playerNumber);

    return playerState.production >= 20 && planet.canUpgrade();
  }

  bool upgradePlanet(int playerNumber, Planet planet) {
    final playerState = game.controller.getPlayerState(playerNumber);

    if (!canUpgradePlanet(playerNumber, planet)) {
      return false;
    }

    planet.upgrade();
    final capacity = scanCapacity(playerState);
    playerState.addCapacityAndResource(capacity, Resources(production: -20));

    return true;
  }

  bool canAddBuilding(int playerNumber, Planet planet, Building building) {
    final playerState = game.controller.getPlayerState(playerNumber);
    final hasResources =
        playerState.credit >= building.cost && playerState.production >= 10;

    return hasResources && planet.canBuild(building);
  }

  bool addBuilding(int playerNumber, Planet planet, Building building) {
    final playerState = game.controller.getPlayerState(playerNumber);

    if (!canAddBuilding(playerNumber, planet, building)) {
      return false;
    }

    planet.build(building);
    final capacity = scanCapacity(playerState);
    playerState.addCapacityAndResource(capacity,
        Resources(credit: -building.cost.toDouble(), production: -10));

    return true;
  }

  bool canCreateShip(int playerNumber, ShipTemplate tmpl) {
    final playerState = game.controller.getPlayerState(playerNumber);

    return playerState.credit >= tmpl.cost() && playerState.production >= 5;
  }

  bool createShip(Cell cell, int playerNumber, ShipTemplate tmpl) {
    if (cell.ship != null) {
      return false;
    }
    if (!canCreateShip(playerNumber, tmpl)) {
      return false;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    playerState.addResource(Resources(credit: -tmpl.cost(), production: -5));

    game.mapGrid.createShipAt(cell, playerNumber, tmpl);

    return true;
  }
}
