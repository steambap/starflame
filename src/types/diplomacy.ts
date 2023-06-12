import { ObjectId } from "./object_id";

export type DiplomaticState = 'enemies' | 'neutral' | 'allies';

export interface DiplomaticStatus {
    playerIdFrom: ObjectId;
    playerIdTo: ObjectId;
    playerFromAlias: string;
    playerToAlias: string;
    statusFrom: DiplomaticState;
    statusTo: DiplomaticState;
    actualStatus: DiplomaticState;
};

export interface DiplomacyEvent {
    playerId: ObjectId;
    type: string;
    data: DiplomaticStatus;
    sentDate: Date;
    sentTick: number;
};
