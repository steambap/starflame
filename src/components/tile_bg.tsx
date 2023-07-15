import { Circle } from "react-konva";
import { Tile } from "../types/map_loc";

const TileBG = ({ tile }: { tile: Tile }) => {
  if (tile === "gravityRift") {
    return <Circle radius={12} shadowColor="white" shadowBlur={8} fill="black" />;
  }
  if (tile === "system") {
    return <Circle radius={24} strokeWidth={1} stroke="white" />
  }
  if (tile === "asteroidField") {
    return <Circle radius={12} fill="#999999" />
  }
  if (tile === "nebula") {
    return <Circle radius={18} fill="#987621" />
  }

  return null;
};

export default TileBG;
