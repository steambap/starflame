import { Circle } from "react-konva";
import { PlanetType } from "../types/star_system";

const PlanetImg = ({ planet }: { planet: PlanetType }) => {
  if (planet === "barren") {
    return (
      <Circle radius={32} fill="#6b6c6e" shadowBlur={4} shadowColor="white" />
    );
  } else if (planet === "snow") {
    return (
      <Circle radius={32} fill="#669ebc" shadowBlur={4} shadowColor="white" />
    );
  } else if (planet === "lava") {
    return (
      <Circle radius={32} fill="#e67938" shadowBlur={4} shadowColor="#edcc91" />
    );
  } else if (planet === "arid") {
    return (
      <Circle radius={32} fill="#bf9f74" shadowBlur={4} shadowColor="#edcc91" />
    );
  } else if (planet === "swamp") {
    return (
      <Circle radius={32} fill="#98a889" shadowBlur={4} shadowColor="#91c1b4" />
    );
  } else if (planet === "terran") {
    return (
      <Circle radius={32} fill="#6aaa9d" shadowBlur={4} shadowColor="#91c1b4" />
    );
  }

  return null;
};

export default PlanetImg;
