import { StarSystem } from "./star_system";
import { Player } from "./player";
import { MapLoc } from "./map_loc";
import { Rand } from "../rand";

export type GameMode = "aweakening" | "kingOfTheHill";
export type GameGalaxyType =
  | "circular"
  | "triangle";

export interface GameSettings {
  general: {
    seed: number;
  };
  galaxy: {
    galaxyType: GameGalaxyType;
  };
  player: {
    spawnPoint: number;
    startingEnergy: number;
  };
}

export interface GameUserNotification {
  unreadConversations: number | null;
  unreadEvents: number | null;
  unread: number | null;
  turnWaiting: boolean | null;
  defeated: boolean | null;
  afk: boolean | null;
  position: number | null;
}

export interface Game {
  settings: GameSettings;
  galaxy: {
    players: Player[];
    mapData: MapLoc[];
    systems: StarSystem[];
  };
  state: {
    turn: number;
  };
  userNotifications?: GameUserNotification;
  rand: Rand;
}
