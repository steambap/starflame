import { GameSettings, Game } from "../types/game";
import { PlayerService } from "./player";
import { MapCreateService } from "./map_create";
import { Rand } from "../services/rand";
import { ShipService } from "./ship";

export function newGameState(): Omit<Game, "rand" | "settings"> {
  return {
    galaxy: {
      players: [],
      mapData: [],
      systems: [],
      ships: [],
    },
    ctx: {
      turn: 0,
    },
    errors: [],
  };
}

export function create(settings: GameSettings) {
  const game: Game = {
    ...newGameState(),
    settings,
    rand: new Rand({ seed: settings.general.seed }),
  };

  MapCreateService.circular(game);

  PlayerService.createPlayers(game);

  ShipService.setupPlayerStartShip(game);

  return game;
}
