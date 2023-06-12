import { ObjectId } from "./object_id";
import { InfrastructureUpgradeCosts } from "./infrastructure_upgrade";
import { Location } from "./location";
import { MapObject } from "./map_object";
import { PlayerTechnologyLevels } from "./player";
import { Specialist } from "./specialist";

export interface NaturalResources {
    economy: number;
    industry: number;
    science: number;
};

export interface TerraformedResources extends NaturalResources {
    
};

export type InfrastructureType = 'economy' | 'industry' | 'science';

export interface Infrastructure {
    economy: number | null;
    industry: number | null;
    science: number | null;
};

export interface IgnoreBulkUpgrade {
    economy: boolean;
    industry: boolean;
    science: boolean;
};

export interface Star extends MapObject {
    name: string;
    naturalResources: NaturalResources;
    terraformedResources?: TerraformedResources;
    ships: number | null;
    shipsActual?: number;
    specialistId: number | null;
    specialistExpireTick: number | null;
    homeStar: boolean;
    warpGate: boolean;
    isNebula: boolean;
    isAsteroidField: boolean;
    isBinaryStar: boolean;
    isBlackHole: boolean;
    isPulsar: boolean;
    wormHoleToStarId: ObjectId | null;
    ignoreBulkUpgrade?: IgnoreBulkUpgrade;
    infrastructure: Infrastructure;
    isKingOfTheHillStar?: boolean;
    locationNext?: Location;
    specialist?: Specialist | null;
    targeted?: boolean;
    upgradeCosts?: InfrastructureUpgradeCosts;
    manufacturing?: number;
    isInScanningRange?: boolean;
    effectiveTechs?: PlayerTechnologyLevels;
};

export interface StarCaptureResult {
    capturedById: ObjectId;
    capturedByAlias: string;
    captureReward: number;
};
