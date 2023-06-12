import { ObjectId } from "./object_id";

export interface GameEvent {
    id: ObjectId;
    gameId: ObjectId;
    playerId: ObjectId | null;
    tick: number;
    type: string;
    data: any;
    read: boolean;

    date?: Date;
};
