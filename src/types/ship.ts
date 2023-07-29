export type ShipClass =
  | "cruiser"
  | "carrier"
  | "drendnought"
  | "flagship";

export interface Ship {
  id: string;
  name: string;
  type: ShipClass;
  location: string;
  health: number;
  actionPoint: number;
}

export interface ShipTypeData {
  health: number;
  actionPoint: number;
}
