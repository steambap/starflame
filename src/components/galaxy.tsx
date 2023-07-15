import { Group } from "react-konva";
import { Game } from "../types/game";
import { HexService } from "../services/hex";
import { Hexagon } from "./hexagon";
import TileBG from "./tile_bg";

const Galaxy = ({ game }: { game: Game }) => {
  return (
    <Group name="hex-map">
      {game.galaxy.mapData.map((hex) => {
        const loc = HexService.toPixel(hex);

        return (
          <Group position={loc} key={HexService.toStr(hex)}>
            <Hexagon />
            <TileBG tile={hex.tile} />
          </Group>
        );
      })}
    </Group>
  );
};

export default Galaxy;
