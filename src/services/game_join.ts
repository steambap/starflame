import { Game } from "../types/game";
import { ObjectId } from "../types/object_id";
import { Player } from "../types/player";
import AvatarService from "./avatar";
import GameTypeService from "./game_type";

const GameJoinService = {
  assignPlayerToUser(
    game: Game,
    player: Player,
    userId: ObjectId | null,
    alias: string,
    avatar: number
  ) {
    if (!player.isOpenSlot) {
      throw new Error(`The player slot is not open to be filled`);
    }

    // Assign the user to the player.
    player.userId = userId;
    player.alias = alias;
    player.avatar = avatar.toString();
    player.spectators = [];

    // Reset the defeated and afk status as the user may be filling
    // an afk slot.
    player.hasFilledAfkSlot = false;
    player.isOpenSlot = false;
    player.defeated = false;
    player.defeatedDate = null;
    player.missedTurns = 0;
    player.afk = false;
    player.hasSentTurnReminder = false;

    if (!player.userId) {
      player.ready = true;
    }

    if (userId) {
      // Clear out any players the user may be spectating.
      game.galaxy.players.forEach((player) => {
        player.spectators = [];
      });
    }

    game.state.players = game.galaxy.players.filter(
      (p) => !p.defeated && !p.afk
    ).length;
  },

  assignNonUserPlayersToAI(game: Game) {
    // For all AI, assign a random alias and an avatar.
    const players = game.galaxy.players.filter((p) => p.userId == null);

    if (!players.length) {
      return;
    }

    const aliases = AvatarService.listAllAliases();
    const avatars = AvatarService.listAllAvatars();

    for (const player of players) {
      const aliasIndex = game.rand.getRandomNumberBetween(
        0,
        aliases.length - 1
      );
      const avatarIndex = game.rand.getRandomNumberBetween(
        0,
        avatars.length - 1
      );

      const alias = aliases.splice(aliasIndex, 1)[0];
      const avatar = avatars.splice(avatarIndex, 1)[0].id.toString();

      player.alias = alias;
      player.avatar = avatar;
      player.researchingNext = "random";
      player.missedTurns = 0;
      player.hasSentTurnReminder = false;
      player.afk = false;
      player.defeated = false;
      player.defeatedDate = null;
      player.hasFilledAfkSlot = false;

      if (GameTypeService.isTurnBasedGame(game)) {
        player.ready = true;
      }

      // If its a tutorial game we want to keep the slot closed.
      player.isOpenSlot = !GameTypeService.isTutorialGame(game);
    }
  },
};

export default GameJoinService;
