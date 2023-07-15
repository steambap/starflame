import { GameSettings, Game } from "../types/game";
import { PlayerService } from "./player";
import { MapCreateService } from "./map_create";
import { Rand } from "../rand";

export function create(settings: GameSettings) {
  const game: Game = {
    settings,
    galaxy: {
      players: [],
      mapData: [],
      systems: [],
    },
    state: {
      turn: 0,
    },
    rand: new Rand({ seed: settings.general.seed }),
  };

  MapCreateService.circular(game);

  PlayerService.createPlayers(game);

  return game;
}
