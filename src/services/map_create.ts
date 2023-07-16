import { Game } from "../types/game";
import { hexMap, hexOrigin, HexService } from "./hex";
import { MapLoc, Tile } from "../types/map_loc";
import { StarSystem } from "../types/star_system";
import { StarSystemService } from "./star_system";

const numOfAsteroid = 4;
const numOfNebula = 4;

export const MapCreateService = {
  circular(game: Game) {
    const mapData: MapLoc[] = hexMap.slice(0).map((hex) => {
      let tile: Tile = "void";
      const distance = HexService.distance(hexOrigin, hex);
      if (HexService.eq(hexOrigin, hex)) {
        tile = "gravityRift";
      } else if (HexService.isMapCorner(hex)) {
        tile = "gravityRift";
      } else if (distance <= 2) {
        const roll = game.rand.getRandomNumberBetween(1, 3);
        if (roll === 1) {
          tile = "system";
        }
      } else if (distance <= 4) {
        const roll = game.rand.getRandomNumberBetween(1, 7);
        if (roll === 1) {
          tile = "system";
        }
      } else {
        const roll = game.rand.getRandomNumberBetween(1, 11);
        if (roll === 1) {
          tile = "system";
        }
      }

      return {
        ...hex,
        tile,
      };
    });

    const voidList = mapData.filter((hex) => hex.tile === "void");
    voidList.sort(() => 0.5 - game.rand.next());

    for (let i = 0; i < numOfAsteroid; i++) {
      voidList[i].tile = "asteroidField";
    }
    for (let i = numOfAsteroid; i < numOfAsteroid + numOfNebula; i++) {
      voidList[i].tile = "nebula";
    }

    // system gen
    const systems: StarSystem[] = [];
    mapData.forEach((loc) => {
      if (loc.tile !== "system") {
        return;
      }

      const weight = StarSystemService.getTotalWeight();
      const num = game.rand.getRandomNumberBetween(1, weight);
      const type = StarSystemService.getRandPlanet(num);
      const system: StarSystem = {
        id: crypto.randomUUID(),
        name: "test",
        type,
        metal: game.rand.getRandomNumberBetween(1, 9),
        energy: game.rand.getRandomNumberBetween(1, 9),
        loc: {
          q: loc.q,
          r: loc.r,
          s: loc.s,
        },
      };

      systems.push(system);
    });

    game.galaxy.mapData = mapData;
    game.galaxy.systems = systems;
  },
};
