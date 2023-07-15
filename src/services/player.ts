import { Player } from "../types/player";
import { Game } from "../types/game";

export const PlayerService = {
  createPlayers(game: Game) {
    const player: Player = {
      id: crypto.randomUUID(),
      energy: 100,
      defeated: false,
      isCPU: false,
      empireType: "regular",
    };
    const pirate: Player = {
      id: crypto.randomUUID(),
      energy: 10,
      defeated: false,
      isCPU: true,
      empireType: "pirate",
    };
    const czoth: Player = {
      id: crypto.randomUUID(),
      energy: 100,
      defeated: false,
      isCPU: true,
      empireType: "crisis",
    };
    game.galaxy.players = [player, pirate, czoth];
  },
};
