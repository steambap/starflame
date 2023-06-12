import { ObjectId } from "./object_id";

export type CarrierWaypointActionType = 'nothing'|'collectAll'|'dropAll'|'collect'|'drop'|'collectAllBut'|'dropAllBut'|'dropPercentage'|'collectPercentage'|'garrison';

export interface CarrierWaypointBase {
    source: ObjectId;
    destination: ObjectId;
    action: CarrierWaypointActionType;
    actionShips: number;
    delayTicks: number;
};

export interface CarrierWaypoint extends CarrierWaypointBase {
    id: ObjectId;
    ticks?: number;
    ticksEta?: number;
};
