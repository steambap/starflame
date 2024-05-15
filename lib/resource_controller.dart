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
    playerState.runProduction();
  }

  Resources playerIncome(PlayerState state) {
    Resources income = const Resources();

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
    Resources income = const Resources();

    for (final bd in planet.buildings) {
      if (bd == Building.colonyHQ) {
        income +=
            const Resources(production: 1, credit: 3, science: 1, influence: 1);
      } else if (bd == Building.constructionYard) {
        income += const Resources(production: 3);
      } else if (bd == Building.bank) {
        income += const Resources(credit: 8);
      } else if (bd == Building.lab) {
        income += const Resources(science: 3);
      } else if (bd == Building.mediaNetwork) {
        income += const Resources(influence: 3);
      }
    }

    income += Resources(
            food: planet.type.food.toDouble(),
            production: planet.type.production,
            credit: planet.type.credit.toDouble(),
            science: planet.type.science,
            influence: planet.type.influence) *
        planet.citizen;

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
    capacity.citizen = planet.citizen;
    final dataTable = capacity.sectorDataTable;
    dataTable.putIfAbsent(planet.sector, () => SectorData());
    if (planet.buildings.contains(Building.colonyHQ)) {
      dataTable[planet.sector]?.hasHQ = true;
    }

    return capacity;
  }

  double getMaintaince(int playerNumber) {
    return 0;
  }

  bool canAddCitizen(int playerNumber, Planet planet) {
    final playerState = game.controller.getPlayerState(playerNumber);

    return playerState.citizenIdle >= 1 && planet.canAddCitizen();
  }

  bool addCitizen(int playerNumber, Planet planet) {
    final playerState = game.controller.getPlayerState(playerNumber);

    if (!canAddCitizen(playerNumber, planet)) {
      return false;
    }

    playerState.citizenIdle -= 1;
    planet.addCitizen();
    game.playerInfo.updateRender();

    return true;
  }

  bool canRemoveCitizen(int playerNumber, Planet planet) {
    return planet.citizen >= 1;
  }

  bool removeCitizen(int playerNumber, Planet planet) {
    if (!canRemoveCitizen(playerNumber, planet)) {
      return false;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    final sectorData = playerState.sectorDataTable[planet.sector]!;
    if (sectorData.hasHQ) {
      playerState.citizenIdle += 1;
    } else {
      playerState.citizenInTransport += 1;
    }
    planet.removeCitizen();
    game.playerInfo.updateRender();

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
    playerState.addCapacityAndResource(
        capacity, const Resources(production: -20));

    return true;
  }

  bool canAddBuilding(int playerNumber, Planet planet, Building building) {
    final playerState = game.controller.getPlayerState(playerNumber);
    final hasResources = playerState.credit >= building.cost;

    return hasResources && planet.canBuild(building);
  }

  bool addBuilding(int playerNumber, Planet planet, Building building) {
    final playerState = game.controller.getPlayerState(playerNumber);

    if (!canAddBuilding(playerNumber, planet, building)) {
      return false;
    }

    planet.build(building);
    final capacity = scanCapacity(playerState);
    playerState.addCapacityAndResource(
        capacity, Resources(credit: -building.cost.toDouble()));

    return true;
  }

  bool canCreateShip(int playerNumber, ShipTemplate tmpl) {
    final playerState = game.controller.getPlayerState(playerNumber);

    return playerState.production >= tmpl.cost();
  }

  bool createShip(Cell cell, int playerNumber, ShipTemplate tmpl) {
    if (cell.ship != null) {
      return false;
    }
    if (!canCreateShip(playerNumber, tmpl)) {
      return false;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    playerState.addResource(Resources(production: -tmpl.cost()));

    game.mapGrid.createShipAt(cell, playerNumber, tmpl);

    return true;
  }
}
