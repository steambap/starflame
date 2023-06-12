import { Location } from "../types/location";
import { Game } from "../types/game";
import { Star } from "../types/star";
import DistanceService from "./distance";

const StarDistanceService = {
  isLocationTooClose(game: Game, location: Location, otherLocation: Location) {
    const distance = DistanceService.getDistanceBetweenLocations(
      location,
      otherLocation
    );

    return distance < game.constants.distances.minDistanceBetweenStars;
  },
  getClosestUnownedStars(star: Star, stars: Star[], amount: number) {
    let sorted = stars
      .filter((s) => s.id !== star.id) // Exclude the current star.
      .filter((s) => !s.ownedByPlayerId)
      .sort((a, b) => {
        return (
          DistanceService.getDistanceBetweenLocations(
            star.location,
            a.location
          ) -
          DistanceService.getDistanceBetweenLocations(star.location, b.location)
        );
      });

    return sorted.slice(0, amount);
  },
  getClosestUnownedStar(star: Star, stars: Star[]) {
    return this.getClosestUnownedStars(star, stars, 1)[0];
  },
  getClosestUnownedStarsFromLocation(
    location: Location,
    stars: Star[],
    amount: number
  ) {
    let sorted = stars
      .filter((s) => !s.ownedByPlayerId)
      .sort(
        (a, b) =>
          DistanceService.getDistanceBetweenLocations(a.location, location) -
          DistanceService.getDistanceBetweenLocations(b.location, location)
      );

    return sorted.slice(0, amount);
  },
  getClosestUnownedStarFromLocation(location: Location, stars: Star[]) {
    return this.getClosestUnownedStarsFromLocation(location, stars, 1)[0];
  },
  getMaxGalaxyDiameter(locations: Location[]) {
    const diameter = this.getGalaxyDiameter(locations);

    return diameter.x > diameter.y ? diameter.x : diameter.y;
  },
  getGalaxyDiameter(locations: Location[]) {
    let xArray = locations.map((location) => {
      return location.x;
    });
    let yArray = locations.map((location) => {
      return location.y;
    });

    let maxX = Math.max(...xArray);
    let maxY = Math.max(...yArray);

    let minX = Math.min(...xArray);
    let minY = Math.min(...yArray);

    return {
      x: maxX - minX,
      y: maxY - minY,
    };
  },
  getGalacticCenter(): Location {
    return {
      x: 0,
      y: 0,
    };
  },
};

export default StarDistanceService;
