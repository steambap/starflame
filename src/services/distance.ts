import { Location } from "../types/location";

const DistanceService = {
  getDistanceBetweenLocations(loc1: Location, loc2: Location) {
    return Math.hypot(loc2.x - loc1.x, loc2.y - loc1.y);
  },
};

export default DistanceService;
