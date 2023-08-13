import { createSlice } from "@reduxjs/toolkit";
import type { PayloadAction } from "@reduxjs/toolkit";
import { Game, GameSettings } from "../types/game";
import tutorialSettings from "../data/tutorial.json"
import { create, newGameState } from "../services/game_create";
import { Rand } from "../services/rand";

const initialState: Game = {
  ...newGameState(),
  settings: tutorialSettings as GameSettings,
  rand: new Rand({ seed: 0 }),
};

function withError(state: Game, message: string): Game {
  let pastErr: Error[] = [];
  if (state.error) {
    pastErr = state.error.errors;
    pastErr.push(new Error(state.error.message));
  }

  return {
    ...state,
    error: {
      type: "error",
      message,
      errors: pastErr,
    },
  }
}

export const gameStateSlice = createSlice({
  name: "game_state",
  initialState,
  reducers: {
    init(_, action: PayloadAction<GameSettings>) {
      const game = create(action.payload);

      return game;
    },
    makeMove(state, action: PayloadAction<any>) {
      return {
        ...state,
        ...action.payload,
      }
    }
  },
});

export const { init, makeMove } = gameStateSlice.actions;

export default gameStateSlice.reducer;
