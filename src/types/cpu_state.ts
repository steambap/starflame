export interface KnownAttack {
  arrivalTick: number;
  starId: string;
  carriersOnTheWay: string[];
}

export interface InvasionInProgress {
  arrivalTick: number;
  star: string;
}

export interface CpuState {
  knownAttacks: KnownAttack[];
  invasionsInProgress: InvasionInProgress[];
  startedClaims: string[];
}