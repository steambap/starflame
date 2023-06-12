import { Carrier } from "./carrier";
import { CarrierWaypoint } from "./carrier_waypoint";
import { Star } from "./star";

export interface CarrierActionWaypoint {
  carrier: Carrier;
  star: Star;
  waypoint: CarrierWaypoint;
}
