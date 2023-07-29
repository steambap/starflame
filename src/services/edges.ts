import { MapLoc, Tile } from "../types/map_loc";
import { HexService } from "./hex";

export type Edge = Record<string, Record<string, number>>;

export const costTable: Record<Tile, number> = {
  void: 1,
  alphaWormHole: 1,
  betaWormHole: 1,
  asteroidField: 2,
  nebula: 1,
  system: 1,
  gravityRift: Infinity,
};

export function calcEdges(map: MapLoc[]): Edge {
  const edges: Edge = {};

  map.forEach((mapLoc) => {
    edges[mapLoc.id] = {};
    const ns = HexService.getNeighbours(mapLoc);
    ns.forEach((neighbour) => {
      const id = HexService.toStr(neighbour);
      const nLoc = map.find((loc) => loc.id === id);
      if (!nLoc) {
        return;
      }
      const cost = costTable[nLoc.tile];
      if (cost === Infinity) {
        return;
      }

      edges[mapLoc.id][nLoc.id] = cost;
    });
  });

  return edges;
}
