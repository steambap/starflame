export type ShipClass =
  | "patrol"
  | "destroyer"
  | "cruiser"
  | "carrier"
  | "drendnought"
  | "flagship";

export interface Ship {
  id: string;
  owner: string;
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
