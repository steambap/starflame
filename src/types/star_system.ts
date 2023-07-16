import { Hex } from "./hex";

export type PlanetType =
  | "barren"
  | "swamp"
  | "lava"
  | "snow"
  | "arid"
  | "terran";

export interface StarSystem {
  id: string;
  name: string;
  metal: number;
  energy: number;
  loc: Hex;
  type: PlanetType;
}
