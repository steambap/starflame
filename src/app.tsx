import { Stage, Layer, Group, Star, Path } from "react-konva";
import tutorial from "./data/tutorial.json";
import GameCreateService from "./services/game_create";
import { GameSettings } from "./types/game";

function App() {
  const game = GameCreateService.create(tutorial as GameSettings);

  return (
    <>
      <Stage draggable width={window.innerWidth} height={window.innerHeight}>
        <Layer>
          {game.galaxy.stars.map((star) => {
            const player = game.galaxy.players.find(p => p.id === star.ownedByPlayerId);
            const playerColor = player ? player.colour.value : "#c0c0c0";
            return (
              <Group x={star.location.x} y={star.location.y} key={star.id}>
                <Path
                  fill={playerColor}
                  data="M 83.865234 51.554688 L 39.728516 128.00195 L 83.865234 204.44922 L 172.13867 204.44922 L 157.125 178.44531 L 157.12305 178.44922 L 98.873047 178.44922 L 69.751953 128.00195 L 98.873047 77.554688 L 157.12305 77.554688 L 172.13477 51.554688 L 83.865234 51.554688 z"
                  x={-34}
                  y={-34}
                  scaleX={0.26458333}
                  scaleY={0.26458333}
                />
                <Star
                  numPoints={6}
                  innerRadius={6}
                  outerRadius={12}
                  fill={playerColor}
                />
              </Group>
            );
          })}
        </Layer>
      </Stage>
      <div className="fixed top-0 right-0">Tutorial - Learn to Play</div>
    </>
  );
}

export default App;
