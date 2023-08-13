import { useLayoutEffect } from "react";
import { useDispatch } from "react-redux";
import Camera from "./components/camera";
import Galaxy from "./components/galaxy";
import tutorialSettings from "./data/tutorial.json"
import { init } from "./stores/game_state_slice";
import { GameSettings } from "./types/game";

function App() {
  const dispatch = useDispatch();
  useLayoutEffect(() => {
    dispatch(init(tutorialSettings as GameSettings))
  }, []);

  return (
    <>
      <Camera>
        <Galaxy />
      </Camera>
      <div className="fixed top-0 right-0">
        <div>Tutorial - Learn to Play</div>
      </div>
    </>
  );
}

export default App;
