import { createSlice } from "@reduxjs/toolkit";
import type { PayloadAction } from "@reduxjs/toolkit";
import { Hex } from "../types/hex";
import { HexService } from "../services/hex";

export interface CameraState {
  x: number;
  y: number;
}

const initialState: CameraState = {
  x: 0,
  y: 0,
};

export const cameraSlice = createSlice({
  name: "camera",
  initialState,
  reducers: {
    lookAt(state, action: PayloadAction<CameraState>) {
      state.x = action.payload.x;
      state.y = action.payload.y;
    },
    lookAtHex(state, action: PayloadAction<Hex>) {
      const pos = HexService.toPixel(action.payload);
      state.x = pos.x;
      state.y = pos.y;
    },
  },
});

export const { lookAt, lookAtHex } = cameraSlice.actions;

export default cameraSlice.reducer;
