import { ObjectId } from "./object_id";
import { DiplomaticState } from "./diplomacy";
import { PlayerStatistics } from "./player_stats";
import { CpuState } from "./cpu_state";

export type PlayerShape = "circle" | "square" | "diamond" | "hexagon";
export type ResearchType =
  | "scanning"
  | "hyperspace"
  | "terraforming"
  | "experimentation"
  | "weapons"
  | "banking"
  | "manufacturing"
  | "specialists"
  | "random";
export type ResearchTypeNotRandom =
  | "scanning"
  | "hyperspace"
  | "terraforming"
  | "experimentation"
  | "weapons"
  | "banking"
  | "manufacturing"
  | "specialists";

export interface PlayerColour {
  alias: string;
  value: string;
}

export interface PlayerLedger {
  credits: PlayerLedgerDebt[];
  creditsSpecialists: PlayerLedgerDebt[];
}

export interface PlayerLedgerDebt {
  playerId: ObjectId;
  debt: number;
}

export interface PlayerReputation {
  playerId: ObjectId;
  score: number;
}

export interface ResearchProgress {
  level: number;
  progress?: number;
}

export interface PlayerResearch {
  scanning: ResearchProgress;
  hyperspace: ResearchProgress;
  terraforming: ResearchProgress;
  experimentation: ResearchProgress;
  weapons: ResearchProgress;
  banking: ResearchProgress;
  manufacturing: ResearchProgress;
  specialists: ResearchProgress;
}

export interface PlayerTechnologyLevels {
  scanning: number;
  hyperspace: number;
  terraforming: number;
  experimentation: number;
  weapons: number;
  banking: number;
  manufacturing: number;
  specialists: number;
}

export interface PlayerDiplomaticState {
  playerId: ObjectId;
  status: DiplomaticState;
}

export interface Player {
  id: ObjectId;
  userId: ObjectId | null;
  isRealUser?: boolean;
  isAIControlled?: boolean;
  homeStarId: ObjectId | null;
  alias: string;
  avatar: string | null;
  notes?: string | null;
  colour: {
    alias: string;
    value: string;
  };
  shape: PlayerShape;
  lastSeen: Date | null;
  isOnline?: boolean | null;
  lastSeenIP?: string | null;
  hasDuplicateIP?: boolean;
  researchingNow: ResearchTypeNotRandom;
  researchingNext: ResearchType;
  credits: number;
  creditsSpecialists: number;
  isOpenSlot: boolean;
  defeated: boolean;
  defeatedDate: Date | null;
  afk: boolean;
  renownToGive: number;
  ready: boolean;
  readyToCycle: boolean;
  readyToQuit: boolean;
  missedTurns: number;
  hasSentTurnReminder: boolean;
  hasFilledAfkSlot: boolean;
  research: PlayerResearch;
  ledger: PlayerLedger;
  reputations: PlayerReputation[];
  diplomacy: PlayerDiplomaticState[];
  spectators: ObjectId[];
  stats?: PlayerStatistics;
  isKingOfTheHill?: boolean;
  isInScanningRange?: boolean;
  currentResearchTicksEta?: number | null;
  nextResearchTicksEta?: number | null;
  cpuState?: CpuState | null;
  hasPerspective?: boolean;
}

export interface PlayerColourShapeCombination {
  colour: PlayerColour;
  shape: PlayerShape;
}
