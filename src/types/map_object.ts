import { ObjectId } from "./object_id";
import { Location } from "./location";

export interface MapObject {
    id: ObjectId;
    ownedByPlayerId: ObjectId | null;
    location: Location;
};

export interface MapObjectWithVisibility extends MapObject {
    isAlwaysVisible?: boolean;
};
