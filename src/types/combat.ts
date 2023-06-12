import { ObjectId } from "./object_id";
import { Specialist } from "./specialist";

export interface Defender {
    ships: number;
    weaponsLevel: number;
};

export interface Attacker {
    ships: number;
    weaponsLevel: number;
};

export interface CombatWeapons {
    defender: number;
    defenderBase: number;
    attacker: number;
    attackerBase: number;
};

export interface CombatPart {
    defender: number;
    attacker: number;
};

export interface CombatStar {
    id: ObjectId;
    ownedByPlayerId: ObjectId | null;
    specialist: Specialist | null;
    before: number;
    lost: number;
    after: number;
    scrambled: boolean;
};

export interface CombatCarrier {
    id: ObjectId;
    name: string;
    ownedByPlayerId: ObjectId;
    specialist: Specialist | null;
    before: number | string;
    lost: number | string;
    after: number | string;
    scrambled: boolean;
};

export interface CombatResultShips {
    weapons: CombatWeapons;
    before: CombatPart;
    after: CombatPart;
    lost: CombatPart;
    needed?: CombatPart | null;
};

export interface CombatResult extends CombatResultShips {
    star: CombatStar | null;
    carriers: CombatCarrier[];
};
