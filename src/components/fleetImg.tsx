import { Image } from "react-konva";
import assets from "../services/preload";

const FleetImg = () => {
  return <Image image={assets.ship} x={-72} y={-72} />;
};

export default FleetImg;
