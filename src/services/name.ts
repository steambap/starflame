import starNames from "../data/star_names.json";

const NameService = {
  getRandomStarNames(count: number) {
    const shuffled = starNames.slice(0).sort(() => 0.5 - Math.random());

    return shuffled.slice(0, count);
  },
};

export default NameService;
