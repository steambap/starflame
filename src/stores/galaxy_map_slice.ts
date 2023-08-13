import { createSlice } from "@reduxjs/toolkit";
import type { PayloadAction } from "@reduxjs/toolkit";
import { xor } from "../services/helper";

export interface GalaxyMapState {
  hexSelected: string;
  shipSelected: string[];
  moveRange: Record<string, string[]>;
}

const initialState: GalaxyMapState = {
  hexSelected: "",
  shipSelected: [],
  moveRange: {},
};

export const galaxyMapSlice = createSlice({
  name: "galaxy_map",
  initialState,
  reducers: {
    select(state, action: PayloadAction<string>) {
      state.hexSelected = action.payload;
    },
    toggleShip(state, action: PayloadAction<string>) {
      state.shipSelected = xor(state.shipSelected, action.payload);
    }
  },
});

export const { select, toggleShip } = galaxyMapSlice.actions;

export default galaxyMapSlice.reducer;
