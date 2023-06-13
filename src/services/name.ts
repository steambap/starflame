import { Game } from "../types/game";
import starNames from "../data/star_names.json";

const NameService = {
  getRandomStarNames(game: Game, count: number) {
    const shuffled = starNames.slice(0).sort(() => 0.5 - game.rand.next());

    return shuffled.slice(0, count);
  },
};

export default NameService;
