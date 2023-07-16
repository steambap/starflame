import { Hex } from "./hex";

export type Tile =
  | "void"
  | "system"
  | "asteroidField"
  | "nebula"
  | "gravityRift"
  | "alphaWormHole"
  | "betaWormHole";

export interface MapLoc extends Hex {
  tile: Tile;
}
