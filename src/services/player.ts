import { ObjectId } from "../types/object_id";
import { Game } from "../types/game";
import { Location } from "../types/location";
import {
  Player,
  PlayerColour,
  PlayerShape,
  ResearchTypeNotRandom,
  PlayerColourShapeCombination,
} from "../types/player";
import CarrierService from "./carrier";
import StarService from "./star";
import colours from "../data/colours.json";
import MapService from "./map";
import TechnologyService from "./technology";
import StarDistanceService from "./star_distance";

const PlayerService = {
  getById(game: Game, playerId: ObjectId) {
    return game.galaxy.players.find((p) => p.id === playerId);
  },
  createEmptyPlayer(
    game: Game,
    colour: PlayerColour,
    shape: PlayerShape
  ): Player {
    let researchingNow: ResearchTypeNotRandom = "terraforming";
    let researchingNext: ResearchTypeNotRandom = "terraforming";

    let player: Player = {
      id: crypto.randomUUID(),
      userId: null,
      homeStarId: null,
      alias: "Empty Slot",
      avatar: null,
      notes: null,
      colour: colour,
      shape: shape,
      lastSeen: null,
      lastSeenIP: null,
      researchingNow,
      researchingNext,
      credits: game.settings.player.startingCredits,
      creditsSpecialists: game.settings.player.startingCreditsSpecialists,
      isOpenSlot: true,
      defeated: false,
      defeatedDate: null,
      afk: false,
      renownToGive: game.settings.general.playerLimit,
      ready: false,
      readyToCycle: false,
      readyToQuit: false,
      missedTurns: 0,
      hasSentTurnReminder: false,
      hasFilledAfkSlot: false,
      research: {
        terraforming: {
          level: game.settings.technology.startingTechnologyLevel.terraforming,
        },
        experimentation: {
          level:
            game.settings.technology.startingTechnologyLevel.experimentation,
        },
        scanning: {
          level: game.settings.technology.startingTechnologyLevel.scanning,
        },
        hyperspace: {
          level: game.settings.technology.startingTechnologyLevel.hyperspace,
        },
        manufacturing: {
          level: game.settings.technology.startingTechnologyLevel.manufacturing,
        },
        banking: {
          level: game.settings.technology.startingTechnologyLevel.banking,
        },
        weapons: {
          level: game.settings.technology.startingTechnologyLevel.weapons,
        },
        specialists: {
          level: game.settings.technology.startingTechnologyLevel.specialists,
        },
      },
      ledger: {
        credits: [],
        creditsSpecialists: [],
      },
      reputations: [],
      diplomacy: [],
      spectators: [],
    };

    this._setDefaultResearchTechnology(game, player as any);

    return player;
  },

  createEmptyPlayers(game: Game) {
    let players: Player[] = [];

    let shapeColours = this._generatePlayerColourShapeList(
      game,
      game.settings.general.playerLimit
    );

    for (let i = 0; i < game.settings.general.playerLimit; i++) {
      let shapeColour = shapeColours[i];

      players.push(
        this.createEmptyPlayer(game, shapeColour.colour, shapeColour.shape)
      );
    }

    if (game.galaxy.homeStars && game.galaxy.homeStars.length) {
      this._distributePlayerLinkedHomeStars(game, players);
    } else {
      this._distributePlayerHomeStars(game, players);
    }

    if (game.galaxy.linkedStars && game.galaxy.linkedStars.length) {
      this._distributePlayerLinkedStartingStars(game, players);
    } else {
      this._distributePlayerStartingStars(game, players);
    }

    return players;
  },
  _generatePlayerColourShapeList(game: Game, playerCount: number) {
    const shapes: PlayerShape[] = ["circle", "square", "diamond", "hexagon"];

    const combinations: PlayerColourShapeCombination[] = [];

    for (let shape of shapes) {
      for (let colour of colours) {
        combinations.push({
          shape,
          colour,
        });
      }
    }

    combinations.sort(() => 0.5 - game.rand.next());

    return combinations.slice(0, playerCount);
  },
  _distributePlayerLinkedHomeStars(game: Game, players: Player[]) {
    for (let player of players) {
      let homeStarId = game.galaxy.homeStars!.pop()!;

      // Set up the home star
      const homeStar = StarService.getById(game, homeStarId);
      if (!homeStar) {
        throw new Error("Unknown home star");
      }

      StarService.setupHomeStar(game, homeStar, player, game.settings);
    }
  },

  _distributePlayerHomeStars(game: Game, players: Player[]) {
    // Divide the galaxy into equal chunks, each player will spawned
    // at near equal distance from the center of the galaxy.
    const starLocations = game.galaxy.stars.map((s) => s.location);

    // Calculate the center point of the galaxy as we need to add it onto the starting location.
    let galaxyCenter = MapService.getGalaxyCenterOfMass(starLocations);

    const distanceFromCenter = this._getDesiredPlayerDistanceFromCenter(game);

    let radians = this._getPlayerStartingLocationRadians(
      game.settings.general.playerLimit
    );

    // Create each player starting at angle 0 at a distance of half the galaxy radius

    for (let player of players) {
      let homeStar = this._getNewPlayerHomeStar(
        game,
        starLocations,
        galaxyCenter,
        distanceFromCenter,
        radians
      );

      // Set up the home star
      StarService.setupHomeStar(game, homeStar, player, game.settings);
    }
  },
  _getDesiredPlayerDistanceFromCenter(game: Game) {
    let distanceFromCenter;
    const locations = game.galaxy.stars.map((s) => s.location);

    // doughnut galaxies need the distance from the center needs to be slightly more than others
    // spiral galaxies need the distance to be slightly less, and they have a different galactic center
    if (game.settings.galaxy.galaxyType === "doughnut") {
      distanceFromCenter =
        (StarDistanceService.getMaxGalaxyDiameter(locations) / 2) * (3 / 4);
    } else if (game.settings.galaxy.galaxyType === "spiral") {
      distanceFromCenter =
        StarDistanceService.getMaxGalaxyDiameter(locations) / 2 / 2;
    } else {
      // The desired distance from the center is on two thirds from the galaxy center and the edge
      // for all galaxies other than doughnut and spiral.
      distanceFromCenter =
        (StarDistanceService.getMaxGalaxyDiameter(locations) / 2) * (2 / 3);
    }

    return distanceFromCenter;
  },
  _distributePlayerLinkedStartingStars(game: Game, players: Player[]) {
    for (let player of players) {
      let linkedStars = game.galaxy.linkedStars.pop()!;

      for (let starId of linkedStars) {
        let star = StarService.getById(game, starId);
        if (!star) {
          throw new Error("Unknow star to distribute");
        }

        StarService.setupPlayerStarForGameStart(game, star, player);
      }
    }
  },

  _distributePlayerStartingStars(game: Game, players: Player[]) {
    // The fairest way to distribute stars to players is to
    // iterate over each player and give them 1 star at a time, this is arguably the fairest way
    // otherwise we'll end up with the last player potentially having a really bad position as their
    // stars could be miles away from their home star.
    let starsToDistribute = game.settings.player.startingStars - 1;

    while (starsToDistribute--) {
      for (let player of players) {
        let homeStar = StarService.getById(game, player.homeStarId!);
        if (!homeStar) {
          throw new Error("Unknown home star");
        }

        // Get X closest stars to the home star and also give those to the player.
        let s = StarDistanceService.getClosestUnownedStar(
          homeStar,
          game.galaxy.stars
        );

        // Set up the closest star.
        StarService.setupPlayerStarForGameStart(game, s, player);
      }
    }
  },
  _getNewPlayerHomeStar(
    game: Game,
    starLocations: Location[],
    galaxyCenter: Location,
    distanceFromCenter: number,
    radians: number[]
  ) {
    switch (game.settings.specialGalaxy.playerDistribution) {
      case "circular":
        return this._getNewPlayerHomeStarCircular(
          game,
          starLocations,
          galaxyCenter,
          distanceFromCenter,
          radians
        );
      case "random":
        return this._getNewPlayerHomeStarRandom(game);
    }
  },

  _getNewPlayerHomeStarCircular(
    game: Game,
    starLocations: Location[],
    galaxyCenter: Location,
    distanceFromCenter: number,
    radians: number[]
  ) {
    // Get the player's starting location.
    let startingLocation = this._getPlayerStartingLocation(
      game,
      radians,
      galaxyCenter,
      distanceFromCenter
    );

    // Find the star that is closest to this location, that will be the player's home star.
    let homeStar = StarDistanceService.getClosestUnownedStarFromLocation(
      startingLocation,
      game.galaxy.stars
    );

    return homeStar;
  },

  _getNewPlayerHomeStarRandom(game: Game) {
    // Pick a random unowned star.
    let unownedStars = game.galaxy.stars.filter(
      (s) => s.ownedByPlayerId == null
    );

    let rnd = game.rand.getRandomNumber(unownedStars.length);

    return unownedStars[rnd];
  },
  _getPlayerStartingLocationRadians(playerCount: number) {
    const increment = ((360 / playerCount) * Math.PI) / 180;
    let current = 0;

    let radians: number[] = [];

    for (let i = 0; i < playerCount; i++) {
      radians.push(current);
      current += increment;
    }

    return radians;
  },
  _getPlayerStartingLocation(
    game: Game,
    radians: number[],
    galaxyCenter: Location,
    distanceFromCenter: number
  ) {
    // Pick a random radian for the player's starting position.
    let radianIndex = game.rand.getRandomNumber(radians.length);
    let currentRadians = radians.splice(radianIndex, 1)[0];

    // Get the desired player starting location.
    let startingLocation = {
      x: distanceFromCenter * Math.cos(currentRadians),
      y: distanceFromCenter * Math.sin(currentRadians),
    };

    // Add the galaxy center x and y so that the desired location is relative to the center.
    startingLocation.x += galaxyCenter.x;
    startingLocation.y += galaxyCenter.y;

    return startingLocation;
  },
  _setDefaultResearchTechnology(game: Game, player: Player) {
    let enabledTechs = TechnologyService.getEnabledTechnologies(game);

    player.researchingNow = enabledTechs[0] || "weapons";
    player.researchingNext = player.researchingNow;
  },

  createHomeStarCarriers(game: Game) {
    let carriers: any[] = [];

    for (let i = 0; i < game.galaxy.players.length; i++) {
      let player = game.galaxy.players[i];

      let homeCarrier = this.createHomeStarCarrier(game, player);

      carriers.push(homeCarrier);
    }

    return carriers;
  },

  createHomeStarCarrier(game: Game, player: Player) {
    let homeStar = StarService.getPlayerHomeStar(game.galaxy.stars, player);

    if (!homeStar) {
      throw new Error(
        "The player must have a home star in order to set up a carrier"
      );
    }

    // Create a carrier for the home star.
    let homeCarrier = CarrierService.createAtStar(
      homeStar,
      game.galaxy.carriers
    );

    return homeCarrier;
  },
};

export default PlayerService;
