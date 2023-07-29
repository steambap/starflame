import { ShipClass, Ship, ShipTypeData } from "../types/ship";

export const ShipSettings: Record<ShipClass, ShipTypeData> = {
  cruiser: { health: 670, actionPoint: 3 },
  carrier: { health: 1280, actionPoint: 2 },
  drendnought: { health: 2950, actionPoint: 2 },
  flagship: { health: 4000, actionPoint: 2 },
};

function newShip(type: ShipClass, location: string): Ship {
  const { health, actionPoint } = ShipSettings[type];
  return {
    id: crypto.randomUUID(),
    name: "",
    type,
    location,
    health,
    actionPoint,
  };
}

export const ShipService = {
  newShip,
};
