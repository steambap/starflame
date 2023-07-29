import { Image } from "react-konva";
import { PlanetType } from "../types/star_system";
import assets from "../services/preload";

const PlanetImg = ({ planet }: { planet: PlanetType }) => {
  if (planet === "ice") {
    return <Image image={assets.ice} x={-72} y={-72} />;
  } else if (planet === "lava") {
    return <Image image={assets.lava} x={-72} y={-72} />;
  } else if (planet === "arid") {
    return <Image image={assets.arid} x={-72} y={-72} />;
  } else if (planet === "swamp") {
    return <Image image={assets.swamp} x={-72} y={-72} />;
  } else if (planet === "terran") {
    return <Image image={assets.terran} x={-72} y={-72} />;
  }

  return null;
};

export default PlanetImg;
