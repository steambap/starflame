import { Game, GameSettings } from "../types/game";
import GameJoinService from "./game_join";
import MapService from "./map";
import validate from "./game_create_validation";
import StarService from "./star";
import PlayerService from "./player";
import { Rand } from "../rand";

const GameCreateService = {
  create(settings: GameSettings) {
    const isTutorial = settings.general.type === "tutorial";

    // If it isn't a tutorial
    // then that game must be set as a custom game.
    if (!isTutorial) {
      settings.general.type = "custom"; // All user games MUST be custom type.
      settings.general.timeMachine = "disabled"; // Time machine is disabled for user created games.
      settings.general.featured = false; // Stop any tricksters.
    }

    if (
      settings.general.name.trim().length < 3 ||
      settings.general.name.trim().length > 24
    ) {
      throw new Error("Game name must be between 3 and 24 characters.");
    }

    const game: Game = {
      id: crypto.randomUUID(),
      settings,
      constants: {
        distances: {
          lightYear: 50,
          minDistanceBetweenStars: 50,
          maxDistanceBetweenStars: 500,
          warpSpeedMultiplier: 3,
          galaxyCenterLocation: { x: 0, y: 0 },
        },
        research: {
          progressMultiplier: 50,
          sciencePointMultiplier: 1,
          experimentationMultiplier: 1,
        },
        star: {
          resources: {
            minNaturalResources: 10,
            maxNaturalResources: 50,
          },
          infrastructureCostMultipliers: {
            warpGate: 50,
            economy: 2.5,
            industry: 5,
            science: 20,
            carrier: 10,
          },
          infrastructureExpenseMultipliers: {
            cheap: 1,
            standard: 2,
            expensive: 4,
            veryExpensive: 8,
            crazyExpensive: 16,
          },
          specialistsExpenseMultipliers: {
            standard: 2,
            expensive: 4,
            veryExpensive: 8,
            crazyExpensive: 16,
          },
          captureRewardMultiplier: 18,
          homeStarDefenderBonusMultiplier: 1,
        },
        diplomacy: {
          upkeepExpenseMultipliers: {
            none: 0,
            cheap: 0.05,
            standard: 0.1,
            expensive: 0.15,
            crazyExpensive: 0.25,
          },
        },
        player: {
          rankRewardMultiplier: 1,
          bankingCycleRewardMultiplier: 75,
        },
        specialists: {
          monthlyBanAmount: 3,
        },
      },
      galaxy: {
        players: [],
        carriers: [],
        stars: [],
        linkedStars: [],
      },
      state: {
        locked: false,
        tick: 0,
        paused: true,
        productionTick: 0,
        startDate: null,
        endDate: null,
        lastTickDate: null,
        ticksToEnd: null,
        stars: 0,
        starsForVictory: 0,
        players: 0,
        winner: null,
        cleaned: false,
        leaderboard: [],
      },
      rand: new Rand({ seed: settings.general.seed }),
    };

    // For non-custom galaxies we need to check that the player has actually provided
    // enough stars for each player.
    let desiredStarCount =
      game.settings.galaxy.starsPerPlayer * game.settings.general.playerLimit;
    let desiredPlayerStarCount =
      game.settings.player.startingStars * game.settings.general.playerLimit;

    if (desiredPlayerStarCount > desiredStarCount) {
      throw new Error(
        `Cannot create a galaxy of ${desiredStarCount} stars with ${game.settings.player.startingStars} stars per player.`
      );
    }

    // Ensure that c2c combat is disabled for orbital games.
    if (
      game.settings.orbitalMechanics.enabled === "enabled" &&
      game.settings.specialGalaxy.carrierToCarrierCombat === "enabled"
    ) {
      game.settings.specialGalaxy.carrierToCarrierCombat = "disabled";
    }

    // Ensure that specialist credits setting defaults token specific settings
    if (game.settings.specialGalaxy.specialistsCurrency === "credits") {
      game.settings.player.startingCreditsSpecialists = 0;
      game.settings.player.tradeCreditsSpecialists = false;
      game.settings.technology.startingTechnologyLevel.specialists = 0;
      game.settings.technology.researchCosts.specialists = "none";
    }

    // Ensure that specialist bans are cleared if specialists are disabled.
    if (game.settings.specialGalaxy.specialistCost === "none") {
      game.settings.specialGalaxy.specialistBans = {
        star: [],
        carrier: [],
      };
    }

    // Ensure that tick limited games have their ticks to end state preset
    if (game.settings.gameTime.isTickLimited === "enabled") {
      game.state.ticksToEnd = game.settings.gameTime.tickLimit;
    } else {
      game.settings.gameTime.tickLimit = null;
      game.state.ticksToEnd = null;
    }

    if (game.settings.galaxy.galaxyType === "custom") {
      game.settings.specialGalaxy.randomWarpGates = 0;
      game.settings.specialGalaxy.randomWormHoles = 0;
      game.settings.specialGalaxy.randomNebulas = 0;
      game.settings.specialGalaxy.randomAsteroidFields = 0;
      game.settings.specialGalaxy.randomBinaryStars = 0;
      game.settings.specialGalaxy.randomBlackHoles = 0;
      game.settings.specialGalaxy.randomPulsars = 0;
    }

    // Clamp max alliances if its invalid (minimum of 1)
    game.settings.diplomacy.maxAlliances = Math.max(
      1,
      Math.min(
        game.settings.diplomacy.maxAlliances,
        game.settings.general.playerLimit - 1
      )
    );

    // Create all of the stars required.
    game.galaxy.homeStars = [];
    game.galaxy.linkedStars = [];

    let starGeneration = MapService.generateStars(
      game,
      desiredStarCount,
      game.settings.general.playerLimit,
      settings.galaxy.customJSON
    );

    game.galaxy.stars = starGeneration.stars;
    game.galaxy.homeStars = starGeneration.homeStars;
    game.galaxy.linkedStars = starGeneration.linkedStars;

    StarService.setupStarsForGameStart(game);

    // Setup players and assign to their starting positions.
    game.galaxy.players = PlayerService.createEmptyPlayers(game);
    game.galaxy.carriers = PlayerService.createHomeStarCarriers(game);

    MapService.generateTerrain(game);

    // Calculate how many stars we have and how many are required for victory.
    game.state.stars = game.galaxy.stars.length;
    game.state.starsForVictory = this._calculateStarsForVictory(game);

    this._setGalaxyCenter(game);

    if (isTutorial) {
      this._setupTutorialPlayers(game);
    }

    validate(game);

    return game;
  },

  _setGalaxyCenter(game: Game) {
    const starLocations = game.galaxy.stars.map((s) => s.location);

    game.constants.distances.galaxyCenterLocation =
      MapService.getGalaxyCenter(starLocations);
  },

  _calculateStarsForVictory(game: Game) {
    if (game.settings.general.mode === "conquest") {
      // TODO: Find a better place for this as its shared in the star service.
      switch (game.settings.conquest.victoryCondition) {
        case "starPercentage":
          return Math.ceil(
            (game.state.stars / 100) * game.settings.conquest.victoryPercentage
          );
        case "homeStarPercentage":
          return Math.max(
            2,
            Math.ceil(
              (game.settings.general.playerLimit / 100) *
                game.settings.conquest.victoryPercentage
            )
          ); // At least 2 home stars needed to win.
        default:
          throw new Error(
            `Unsupported conquest victory condition: ${game.settings.conquest.victoryCondition}`
          );
      }
    }

    // game.settings.conquest.victoryCondition = 'starPercentage'; // TODO: Default to starPercentage if not in conquest mode?

    return game.galaxy.stars.length;
  },

  _setupTutorialPlayers(game: Game) {
    // Dump the player who created the game straight into the first slot and set the other slots to AI.
    GameJoinService.assignPlayerToUser(
      game,
      game.galaxy.players[0],
      "human",
      "Player",
      0
    );
    GameJoinService.assignNonUserPlayersToAI(game);
  },
};

export default GameCreateService;
