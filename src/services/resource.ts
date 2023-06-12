import { Game, GameResourceDistribution } from "../types/game";
import { Location } from "../types/location";
import { NaturalResources } from "../types/star";
import DistanceService from "./distance";
import GameTypeService from "./game_type";
import RandomService from "./random";
import StarDistanceService from "./star_distance";

const ResourceService = {
  distribute(
    game: Game,
    locations: Location[],
    resourceDistribution: GameResourceDistribution
  ) {
    // Note: Always distribute randomly for doughnut and irregular regardless of setting.
    const forcedRandom = ["doughnut", "irregular"].includes(
      game.settings.galaxy.galaxyType
    );

    if (resourceDistribution !== "random" && !forcedRandom) {
      return this._distributeWeightedCenter(game, locations);
    }

    // In all other cases, random.
    return this._distributeRandom(game, locations);
  },

  _distributeRandom(game: Game, locations: Location[]) {
    // Allocate random resources.
    let minResources = game.constants.star.resources.minNaturalResources;
    let maxResources = game.constants.star.resources.maxNaturalResources;

    if (game.settings.galaxy.galaxyType === "circular-balanced") {
      this._distributeRandomMirrored(
        game,
        locations,
        minResources,
        maxResources
      );
    } else {
      this._distributeRandomAny(game, locations, minResources, maxResources);
    }
  },

  _distributeRandomMirrored(
    game: Game,
    locations: Location[],
    minResources: number,
    maxResources: number
  ) {
    let playerCount = game.settings.general.playerLimit;
    const splitRes = GameTypeService.isSplitResources(game);

    for (let i = 0; i < locations.length / playerCount; i++) {
      let resources = this._setResources(minResources, maxResources, splitRes);

      for (let j = 0; j < playerCount; j++) {
        (locations[i * playerCount + j] as any).resources = resources;
      }
    }
  },

  _distributeRandomAny(
    game: Game,
    locations: Location[],
    minResources: number,
    maxResources: number
  ) {
    const splitRes = GameTypeService.isSplitResources(game);

    for (let location of locations) {
      (location as any).resources = this._setResources(
        minResources,
        maxResources,
        splitRes
      );
    }
  },

  _distributeWeightedCenter(game: Game, locations: Location[]) {
    // The closer to the center of the galaxy, the more likely (exponentially) to find stars with higher resources.
    let minResources = game.constants.star.resources.minNaturalResources;
    let maxResources = game.constants.star.resources.maxNaturalResources;
    let galaxyRadius = StarDistanceService.getMaxGalaxyDiameter(locations) / 2;
    let galacticCenter = { x: 0, y: 0 };

    if (game.settings.galaxy.galaxyType == "circular-balanced") {
      this._distributeWeightedCenterMirrored(
        game,
        locations,
        minResources,
        maxResources,
        galaxyRadius,
        galacticCenter
      );
    } else {
      this._distributeWeightedCenterAny(
        game,
        locations,
        minResources,
        maxResources,
        galaxyRadius,
        galacticCenter
      );
    }
  },

  _distributeWeightedCenterMirrored(
    game: Game,
    locations: Location[],
    minResources: number,
    maxResources: number,
    galaxyRadius: number,
    galacticCenter: Location
  ) {
    let playerCount = game.settings.general.playerLimit;
    const splitRes = GameTypeService.isSplitResources(game);

    for (let i = 0; i < locations.length / playerCount; i++) {
      let radius = DistanceService.getDistanceBetweenLocations(
        galacticCenter,
        locations[i * playerCount]
      );

      // The * 0.6 + 0.2 in the function prevents values like 0 or 1, in which case randomisation is gone, and the outcome can only be a min or a max value
      // If you want the differences to be more extreme you can increase the 0.6 and decrease the 0.2 notice how: 1 - 0.6 = 2 * 0.2, keep that relation intact.
      // So for example a good tweak to make the center even stronger and the edges weaker would be to pick * 0.8 + 0.1, and notice again how 1 - 0.8 = 2 * 0.1
      let resources = this._setResources(
        minResources,
        maxResources,
        splitRes,
        (radius / galaxyRadius) * 0.6 + 0.2
      );

      for (let j = 0; j < playerCount; j++) {
        (locations[i * playerCount + j] as any).resources = resources;
      }
    }
  },

  _distributeWeightedCenterAny(
    game: Game,
    locations: Location[],
    minResources: number,
    maxResources: number,
    galaxyRadius: number,
    galacticCenter: Location
  ) {
    const splitRes = GameTypeService.isSplitResources(game);

    for (let location of locations) {
      let radius = DistanceService.getDistanceBetweenLocations(
        galacticCenter,
        location
      );

      // The * 0.6 + 0.2 in the function prevents values like 0 or 1, in which case randomisation is gone, and the outcome can only be a min or a max value
      // If you want the differences to be more extreme you can increase the 0.6 and decrease the 0.2 notice how: 1 - 0.6 = 2 * 0.2, keep that relation intact.
      // So for example a good tweak to make the center even stronger and the edges weaker would be to pick * 0.8 + 0.1, and notice again how 1 - 0.8 = 2 * 0.1
      (location as any).resources = this._setResources(
        minResources,
        maxResources,
        splitRes,
        (radius / galaxyRadius) * 0.6 + 0.2
      );
    }
  },

  _setResources(
    minResources: number,
    maxResources: number,
    isSplitResources: boolean,
    EXP: number = 0.5
  ): NaturalResources {
    if (isSplitResources) {
      return {
        economy: RandomService.getRandomNumberBetweenEXP(
          minResources,
          maxResources,
          EXP
        ),
        industry: RandomService.getRandomNumberBetweenEXP(
          minResources,
          maxResources,
          EXP
        ),
        science: RandomService.getRandomNumberBetweenEXP(
          minResources,
          maxResources,
          EXP
        ),
      };
    }

    let resources = RandomService.getRandomNumberBetweenEXP(
      minResources,
      maxResources,
      EXP
    );

    return {
      economy: resources,
      industry: resources,
      science: resources,
    };
  },
};

export default ResourceService;
