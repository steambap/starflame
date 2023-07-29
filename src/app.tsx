import { useState } from "react";
import tutorial from "./data/tutorial.json";
import { create } from "./services/game_create";
import { Game, GameSettings } from "./types/game";
import Camera from "./components/camera";
import Galaxy from "./components/galaxy";

function App() {
  const [seed, setSeed] = useState("0");
  const [game, setGame] = useState<Game>(
    create(tutorial as GameSettings)
  );

  return (
    <>
      <Camera>
        <Galaxy game={game} />
      </Camera>
      <div className="fixed top-0 right-0">
        <div>Tutorial - Learn to Play</div>
        <div>
          <input value={seed} onChange={(v) => setSeed(v.target.value)} />
        </div>
        <div>
          <button
            onClick={() => {
              tutorial.general.seed = parseInt(seed);
              setGame(create(tutorial as GameSettings));
            }}
          >
            Regen
          </button>
        </div>
      </div>
    </>
  );
}

export default App;
