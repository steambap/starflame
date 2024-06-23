import "scifi_game.dart";
import "player_state.dart";
import "planet.dart";
import "cell.dart";
import "building.dart";
import "ship_hull.dart";
import "resource.dart";
import "sector.dart";
import "sim_props.dart";

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
        income += Resources(
          maintaince: planet.getProp(SimProps.maintainceCost),
          production: planet.getProp(SimProps.production),
          credit: planet.getProp(SimProps.credit),
          science: planet.getProp(SimProps.science),
        );
      }
    }

    return income;
  }

  Resources humanPlayerIncome() {
    final state = game.controller.getHumanPlayerState();

    return playerIncome(state);
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
    if (planet.buildings.contains(Building.colonyHQ)) {
      dataTable.update(
        planet.sector,
        (sectorData) {
          sectorData.hasHQ = true;
          return sectorData;
        },
        ifAbsent: () => SectorData(hasHQ: true),
      );
      dataTable[planet.sector]?.hasHQ = true;
    }

    return capacity;
  }

  double getMaintaince(int playerNumber) {
    return 0;
  }

  bool canAffordBuilding(int playerNumber, Building building) {
    final playerState = game.controller.getPlayerState(playerNumber);

    return playerState.production >= building.cost;
  }

  bool canAddBuilding(int playerNumber, Planet planet, Building building) {
    final hasResources = canAffordBuilding(playerNumber, building);

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
        capacity, Resources(production: -building.cost.toDouble()));

    return true;
  }

  bool canCreateShip(int playerNumber, ShipHull hull) {
    final playerState = game.controller.getPlayerState(playerNumber);

    return playerState.production >= hull.cost;
  }

  bool createShip(Cell cell, int playerNumber, ShipHull hull) {
    if (cell.ship != null) {
      return false;
    }
    if (!canCreateShip(playerNumber, hull)) {
      return false;
    }

    final playerState = game.controller.getPlayerState(playerNumber);
    playerState.addResource(Resources(production: -hull.cost.toDouble()));

    game.mapGrid.createShipAt(cell, playerNumber, hull);

    return true;
  }
}
