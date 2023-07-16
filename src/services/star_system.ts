import { PlanetType } from "../types/star_system";

const weightTable: Record<PlanetType, number> = {
  barren: 1,
  swamp: 6,
  lava: 3,
  snow: 3,
  arid: 8,
  terran: 10,
};

function getTotalWeight() {
  let sum = 0;
  Object.values(weightTable).forEach((val) => {
    sum += val;
  });

  return sum;
}

function getRandPlanet(num: number): PlanetType {
  let sum = 0;
  for (let [k, v] of Object.entries(weightTable)) {
    sum += v;
    if (num <= sum) {
      return k as PlanetType;
    }
  }

  throw new Error("invalid input");
}

export const StarSystemService = {
  getTotalWeight,
  getRandPlanet,
};
