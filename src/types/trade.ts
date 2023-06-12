import { ObjectId } from "./object_id";
import { ResearchTypeNotRandom } from "./player";

export interface TradeTechnology {
    name: ResearchTypeNotRandom;
    level: number;
    cost: number;
};

export interface TradeEvent {
    playerId: ObjectId;
    type: string;
    data: any;
    sentDate: Date;
    sentTick: number;
};

export interface TradeEventTechnology {
    name: string;
    level: number;
    difference: number;
};
