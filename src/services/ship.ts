import { Game } from "../types/game";
import { ShipClass, Ship, ShipTypeData } from "../types/ship";
import { HexService } from "./hex";

export const ShipSettings: Record<ShipClass, ShipTypeData> = {
  patrol: { health: 780, actionPoint: 1 },
  destroyer: { health: 3700, actionPoint: 3 },
  cruiser: { health: 5000, actionPoint: 2 },
  carrier: { health: 5600, actionPoint: 2 },
  drendnought: { health: 8900, actionPoint: 2 },
  flagship: { health: 40000, actionPoint: 2 },
};

function newShip(owner: string, type: ShipClass, location: string): Ship {
  const { health, actionPoint } = ShipSettings[type];
  return {
    id: crypto.randomUUID(),
    owner,
    name: "",
    type,
    location,
    health,
    actionPoint,
  };
}

function setupPlayerStartShip(game: Game) {
  const ships: Ship[] = [];
  const mapCorners = game.galaxy.mapData.filter((hex) =>
    HexService.isMapCorner(hex)
  );
  const spawnPointID = mapCorners[game.settings.player.spawnPoint].id;
  game.galaxy.players.forEach((player) => {
    if (player.empireType === "regular") {
      ships.push(
        newShip(player.id, "flagship", spawnPointID),
        newShip(player.id, "carrier", spawnPointID),
        newShip(player.id, "cruiser", spawnPointID)
      );
    } else if (player.empireType === "pirate") {
      ships.push(newShip(player.id, "patrol", "0,0,0"));
    }
    // No ship for crisis at start
  });

  game.galaxy.ships = ships;
}

export const ShipService = {
  newShip,
  setupPlayerStartShip,
};
