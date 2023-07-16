import { Circle, Image } from "react-konva";
import { Tile } from "../types/map_loc";
import assets from "../services/preload";

const TileBG = ({ tile }: { tile: Tile }) => {
  if (tile === "gravityRift") {
    return <Circle radius={24} shadowColor="white" shadowBlur={8} fill="black" />;
  }
  if (tile === "system") {
    return <Image image={assets.system} x={-72} y={-72} />
  }
  if (tile === "asteroidField") {
    return <Image image={assets.asteroid} x={-72} y={-72} />
  }
  if (tile === "nebula") {
    return <Image image={assets.nebula} x={-72} y={-72} />
  }

  return null;
};

export default TileBG;
