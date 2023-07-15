export type EmpireType = "regular" | "pirate" | "crisis";

export interface Player {
  id: string;
  energy: number;
  defeated: boolean;
  isCPU: boolean;
  empireType: EmpireType;
}
