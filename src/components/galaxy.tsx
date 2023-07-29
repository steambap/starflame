import { Group } from "react-konva";
import { Game } from "../types/game";
import { HexService } from "../services/hex";
import { Hexagon } from "./hexagon";
import TileBG from "./tile_bg";
import PlanetImg from "./planet";
import { StarSystem } from "../types/star_system";

const Galaxy = ({ game }: { game: Game }) => {
  return (
    <Group name="hex-map">
      {game.galaxy.mapData.map((hex) => {
        const loc = HexService.toPixel(hex);
        let system: StarSystem | undefined;
        if (hex.tile === "system") {
          system = game.galaxy.systems.find((system) =>
            HexService.eq(system.loc, hex)
          );
        }

        return (
          <Group
            position={loc}
            key={HexService.toStr(hex)}
            onClick={() => console.log(hex)}
          >
            <Hexagon />
            <TileBG tile={hex.tile} />
            {system && <PlanetImg planet={system.type} />}
          </Group>
        );
      })}
    </Group>
  );
};

export default Galaxy;
