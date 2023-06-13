import { Game } from "../types/game";
import { Star } from "../types/star";
import { Location } from "../types/location";
import NameService from "./name";
import StarService from "./star";
import GameTypeService from "./game_type";
import circularMapGen from "../map_shape/circular";
import CustomMapService from "../map_shape/custom";

const MapService = {
  generateStars(
    game: Game,
    starCount: number,
    playerLimit: number,
    customJSON?: string | null
  ) {
    let stars: Star[] = [];
    let homeStars: any[] = [];
    let linkedStars: any[] = [];

    // Get an array of random star names for however many stars we want.
    const starNames = NameService.getRandomStarNames(game, starCount);

    // Generate all of the locations for stars.
    let starLocations: any[] = [];

    switch (game.settings.galaxy.galaxyType) {
      case "circular":
        starLocations = circularMapGen(
          game,
          starCount,
          game.settings.specialGalaxy.resourceDistribution
        );
        break;
      // case 'spiral':
      //     starLocations = this.spiralMapService.generateLocations(game, starCount, game.settings.specialGalaxy.resourceDistribution);
      //     break;
      // case 'doughnut':
      //     starLocations = this.doughnutMapService.generateLocations(game, starCount, game.settings.specialGalaxy.resourceDistribution);
      //     break;
      // case 'circular-balanced':
      //     starLocations = this.circularBalancedMapService.generateLocations(game, starCount, game.settings.specialGalaxy.resourceDistribution, playerLimit);
      //     break;
      // case 'irregular':
      //     starLocations = this.irregularMapService.generateLocations(game, starCount, game.settings.specialGalaxy.resourceDistribution, playerLimit);
      //     break;
      case "custom":
        starLocations = CustomMapService.generateLocations(
          customJSON!,
          playerLimit
        );
        break;
      default:
        throw new Error(
          `Galaxy type ${game.settings.galaxy.galaxyType} is not supported or has been disabled.`
        );
    }

    let isCustomGalaxy = game.settings.galaxy.galaxyType === "custom";
    let starNamesIndex = 0;

    let unlinkedStars = starLocations.filter((l) => !l.linked);

    // Create a star for all locations returned by the map generator
    for (let i = 0; i < unlinkedStars.length; i++) {
      let starLocation: any = unlinkedStars[i];

      let star: Star;
      let starName = starNames[starNamesIndex++];

      if (isCustomGalaxy) {
        star = StarService.generateCustomGalaxyStar(starName, starLocation);
      } else {
        star = StarService.generateUnownedStar(
          starName,
          starLocation,
          starLocation.resources
        );
      }

      stars.push(star);

      if (starLocation.homeStar) {
        let locLinkedStars: any[] = [];

        for (let linkedLocation of starLocation.linkedLocations) {
          let linkedStar;
          let linkedStarName = starNames[starNamesIndex++];

          if (isCustomGalaxy) {
            linkedStar = StarService.generateCustomGalaxyStar(
              linkedStarName,
              linkedLocation
            );
          } else {
            linkedStar = StarService.generateUnownedStar(
              linkedStarName,
              linkedLocation,
              linkedLocation.resources
            );
          }

          stars.push(linkedStar);
          locLinkedStars.push(linkedStar.id);
        }

        homeStars.push(star.id);
        linkedStars.push(locLinkedStars);
      }
    }

    return {
      stars,
      homeStars,
      linkedStars,
    };
  },

  generateTerrain(game: Game) {
    const playerCount = game.settings.general.playerLimit;

    // If warp gates are enabled, assign random stars to start as warp gates.
    if (game.settings.specialGalaxy.randomWarpGates) {
      this.generateGates(
        game,
        game.galaxy.stars,
        playerCount,
        game.settings.specialGalaxy.randomWarpGates
      );
    }

    // If worm holes are enabled, assign random warp gates to start as worm hole pairs
    if (game.settings.specialGalaxy.randomWormHoles) {
      this.generateWormHoles(
        game,
        game.galaxy.stars,
        playerCount,
        game.settings.specialGalaxy.randomWormHoles
      );
    }

    // If nebulas are enabled, assign random nebulas to start
    if (game.settings.specialGalaxy.randomNebulas) {
      this.generateNebulas(
        game,
        game.galaxy.stars,
        playerCount,
        game.settings.specialGalaxy.randomNebulas
      );
    }

    // If asteroid fields are enabled, assign random asteroid fields to start
    if (game.settings.specialGalaxy.randomAsteroidFields) {
      this.generateAsteroidFields(
        game,
        game.galaxy.stars,
        playerCount,
        game.settings.specialGalaxy.randomAsteroidFields
      );
    }

    // If binary stars are enabled, assign random binary stars to start
    if (game.settings.specialGalaxy.randomBinaryStars) {
      this.generateBinaryStars(
        game,
        game.galaxy.stars,
        playerCount,
        game.settings.specialGalaxy.randomBinaryStars
      );
    }

    // If black holes are enabled, assign random black holes to start
    if (game.settings.specialGalaxy.randomBlackHoles) {
      this.generateBlackHoles(
        game,
        game.galaxy.stars,
        playerCount,
        game.settings.specialGalaxy.randomBlackHoles
      );
    }

    // If pulsars are enabled, assign random pulsars to start
    if (game.settings.specialGalaxy.randomPulsars) {
      this.generatePulsars(
        game,
        game.galaxy.stars,
        playerCount,
        game.settings.specialGalaxy.randomPulsars
      );
    }
  },

  generateGates(game: Game, stars: Star[], playerCount: number, percentage: number) {
    let gateCount = Math.floor(
      ((stars.length - playerCount) / 100) * percentage
    );

    // Pick stars at random and set them to be warp gates.
    do {
      let star =
        stars[game.rand.getRandomNumberBetween(0, stars.length - 1)];

      if (star.homeStar || star.warpGate) {
        gateCount++; // Increment because the while loop will decrement.
      } else {
        star.warpGate = true;
      }
    } while (gateCount--);
  },

  generateWormHoles(
    game: Game,
    stars: Star[],
    playerCount: number,
    percentage: number
  ) {
    let wormHoleCount = Math.floor(
      ((stars.length - playerCount) / 2 / 100) * percentage
    ); // Wormholes come in pairs so its half of stars

    // Pick stars at random and pair them up with another star to create a worm hole.
    while (wormHoleCount--) {
      const remaining = stars.filter((s) => !s.wormHoleToStarId);

      let starA =
        remaining[
          game.rand.getRandomNumberBetween(0, remaining.length - 1)
        ];
      let starB =
        remaining[
          game.rand.getRandomNumberBetween(0, remaining.length - 1)
        ];

      // Check validity of the random selection.
      if (
        starA.homeStar ||
        starB.homeStar ||
        starA.id === starB.id ||
        starA.wormHoleToStarId ||
        starB.wormHoleToStarId
      ) {
        wormHoleCount++; // Increment because the while loop will decrement.
      } else {
        starA.wormHoleToStarId = starB.id;
        starB.wormHoleToStarId = starA.id;

        // Overwrite natural resources if splitResources
        if (GameTypeService.isSplitResources(game)) {
          let minResources =
            game.constants.star.resources.maxNaturalResources * 1.5;
          let maxResources =
            game.constants.star.resources.maxNaturalResources * 3;

          starA.naturalResources.economy = game.rand.getRandomNumberBetween(
            minResources,
            maxResources
          );
          starB.naturalResources.economy = game.rand.getRandomNumberBetween(
            minResources,
            maxResources
          );
        }
      }
    }
  },

  generateNebulas(
    game: Game,
    stars: Star[],
    playerCount: number,
    percentage: number
  ) {
    let count = Math.floor(((stars.length - playerCount) / 100) * percentage);

    // Pick stars at random and set them to be nebulas
    do {
      let star =
        stars[game.rand.getRandomNumberBetween(0, stars.length - 1)];

      if (star.homeStar || star.isNebula) {
        count++; // Increment because the while loop will decrement.
      } else {
        star.isNebula = true;

        // Overwrite natural resources if splitResources
        if (GameTypeService.isSplitResources(game)) {
          let minResources =
            game.constants.star.resources.maxNaturalResources * 1.5;
          let maxResources =
            game.constants.star.resources.maxNaturalResources * 3;

          star.naturalResources.science = game.rand.getRandomNumberBetween(
            minResources,
            maxResources
          );
        }
      }
    } while (count--);
  },

  generateAsteroidFields(
    game: Game,
    stars: Star[],
    playerCount: number,
    percentage: number
  ) {
    let count = Math.floor(((stars.length - playerCount) / 100) * percentage);

    // Pick stars at random and set them to be asteroid fields
    do {
      let star =
        stars[game.rand.getRandomNumberBetween(0, stars.length - 1)];

      if (star.homeStar || star.isAsteroidField) {
        count++; // Increment because the while loop will decrement.
      } else {
        star.isAsteroidField = true;
      }
    } while (count--);
  },

  generateBinaryStars(
    game: Game,
    stars: Star[],
    playerCount: number,
    percentage: number
  ) {
    let count = Math.floor(((stars.length - playerCount) / 100) * percentage);

    // Pick stars at random and set them to be binary stars
    do {
      let star =
        stars[game.rand.getRandomNumberBetween(0, stars.length - 1)];

      if (star.homeStar || star.isBinaryStar) {
        count++; // Increment because the while loop will decrement.
      } else {
        star.isBinaryStar = true;

        // Overwrite the natural resources
        let minResources =
          game.constants.star.resources.maxNaturalResources * 1.5;
        let maxResources =
          game.constants.star.resources.maxNaturalResources * 3;

        // Overwrite natural resources
        if (GameTypeService.isSplitResources(game)) {
          star.naturalResources.industry = game.rand.getRandomNumberBetween(
            minResources,
            maxResources
          );
        } else {
          let resources = game.rand.getRandomNumberBetween(
            minResources,
            maxResources
          );

          star.naturalResources = {
            economy: resources,
            industry: resources,
            science: resources,
          };
        }
      }
    } while (count--);
  },

  generateBlackHoles(
    game: Game,
    stars: Star[],
    playerCount: number,
    percentage: number
  ) {
    let count = Math.floor(((stars.length - playerCount) / 100) * percentage);

    // Pick stars at random and set them to be asteroid fields
    do {
      let star =
        stars[game.rand.getRandomNumberBetween(0, stars.length - 1)];

      if (star.homeStar || star.isBlackHole) {
        count++; // Increment because the while loop will decrement.
      } else {
        star.isBlackHole = true;

        // Overwrite the natural resources
        star.naturalResources.economy = Math.ceil(
          star.naturalResources.economy * 0.2
        );
        star.naturalResources.industry = Math.ceil(
          star.naturalResources.industry * 0.2
        );
        star.naturalResources.science = Math.ceil(
          star.naturalResources.science * 0.2
        );
      }
    } while (count--);
  },

  generatePulsars(
    game: Game,
    stars: Star[],
    playerCount: number,
    percentage: number
  ) {
    let count = Math.floor(((stars.length - playerCount) / 100) * percentage);

    // Pick stars at random and set them to be pulsars
    do {
      let star =
        stars[game.rand.getRandomNumberBetween(0, stars.length - 1)];

      if (star.homeStar || star.isPulsar) {
        count++; // Increment because the while loop will decrement.
      } else {
        star.isPulsar = true;
      }
    } while (count--);
  },

  getGalaxyCenter(starLocations: Location[]) {
    if (!starLocations.length) {
      return {
        x: 0,
        y: 0,
      };
    }

    let maxX = starLocations.sort((a, b) => b.x - a.x)[0].x;
    let maxY = starLocations.sort((a, b) => b.y - a.y)[0].y;
    let minX = starLocations.sort((a, b) => a.x - b.x)[0].x;
    let minY = starLocations.sort((a, b) => a.y - b.y)[0].y;

    return {
      x: (minX + maxX) / 2,
      y: (minY + maxY) / 2,
    };
  },

  getGalaxyCenterOfMass(starLocations: Location[]) {
    if (!starLocations.length) {
      return {
        x: 0,
        y: 0,
      };
    }

    let totalX = starLocations.reduce((total, s) => (total += s.x), 0);
    let totalY = starLocations.reduce((total, s) => (total += s.y), 0);

    return {
      x: totalX / starLocations.length,
      y: totalY / starLocations.length,
    };
  },
};

export default MapService;
