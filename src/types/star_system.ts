import { Hex } from "./hex";

export type PlanetType = "ice" | "swamp" | "lava" | "arid" | "terran";

export interface StarSystem {
  id: string;
  name: string;
  metal: number;
  energy: number;
  loc: Hex;
  type: PlanetType;
}
