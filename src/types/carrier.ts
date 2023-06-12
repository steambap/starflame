import { Location } from "./location";
import { CarrierWaypoint } from "./carrier_waypoint";
import { MapObject } from "./map_object";
import { ObjectId } from "./object_id";
import { Specialist } from "./specialist";
import { PlayerTechnologyLevels } from "./player";

export interface Carrier extends MapObject {
    orbiting: ObjectId | null;
    waypointsLooped: boolean;
    name: string;
    ships: number | null;
    specialistId: number | null;
    specialistExpireTick: number | null;
    specialist: Specialist | null;
    isGift: boolean;
    waypoints: CarrierWaypoint[];
    ticksEta?: number | null;
    ticksEtaTotal?: number | null;
    locationNext: Location | null;
    distanceToDestination?: number;
    effectiveTechs?: PlayerTechnologyLevels;
};

export interface CarrierPosition {
    carrier: Carrier;
    source: ObjectId;
    destination: ObjectId;
    locationCurrent: Location;
    locationNext: Location;
    distanceToSourceCurrent: number;
    distanceToDestinationCurrent: number;
    distanceToSourceNext: number;
    distanceToDestinationNext: number;
};
