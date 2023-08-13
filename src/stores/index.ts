import { configureStore } from "@reduxjs/toolkit";
import cameraReducer from "./camera_slice";
import galaxyMapReducer from "./galaxy_map_slice";
import gameStateReducer from "./game_state_slice";

export const store = configureStore({
  reducer: {
    camera: cameraReducer,
    galaxyMap: galaxyMapReducer,
    gameState: gameStateReducer,
  },
});

// Infer the `RootState` and `AppDispatch` types from the store itself
export type RootState = ReturnType<typeof store.getState>;
// Inferred type: {posts: PostsState, comments: CommentsState, users: UsersState}
export type AppDispatch = typeof store.dispatch;
