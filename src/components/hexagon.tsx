import { RegularPolygon } from "react-konva";
import { HexService, hexOrigin } from "../services/hex";
import { hexSize } from "../data/constants";

export const Hexagon = () => {
  const corners = HexService.polygonCorners(hexOrigin);
  const points: number[] = [];
  corners.forEach((loc) => {
    points.push(loc.x, loc.y);
  });

  return (
    <RegularPolygon
      sides={6}
      radius={hexSize}
      stroke="white"
      fill="transparent"
    />
  );
};
