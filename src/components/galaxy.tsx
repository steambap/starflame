import { useCallback } from "react";
import { Group } from "react-konva";
import { useDispatch, useSelector } from "react-redux";
import { HexService } from "../services/hex";
import { Hexagon } from "./hexagon";
import TileBG from "./tile_bg";
import PlanetImg from "./planet";
import FleetImg from "./fleetImg";
import { StarSystem } from "../types/star_system";
import { select } from "../stores/galaxy_map_slice";
import { RootState } from "../stores";
import { groupBy } from "../services/helper";

const Galaxy = () => {
  const dispatch = useDispatch();
  const selectHex = useCallback((id: string) => {
    dispatch(select(id));
  }, []);
  const gameState = useSelector((state: RootState) => state.gameState);
  const { hexSelected } = useSelector((state: RootState) => state.galaxyMap);
  const selectedHexData = gameState.galaxy.mapData.find(
    (hex) => hex.id === hexSelected
  );
  const mapData = selectedHexData
    ? [
        ...gameState.galaxy.mapData.filter((hex) => hex.id !== hexSelected),
        selectedHexData,
      ]
    : gameState.galaxy.mapData;
  const shipTable = groupBy(gameState.galaxy.ships, (ship) => ship.location);

  return (
    <Group name="hex-map">
      {mapData.map((hex) => {
        const loc = HexService.toPixel(hex);
        let system: StarSystem | undefined;
        if (hex.tile === "system") {
          system = gameState.galaxy.systems.find((system) =>
            HexService.eq(system.loc, hex)
          );
        }
        const stroke = hex.id === hexSelected ? "white" : "#666";
        const hasShip = shipTable[hex.id];

        return (
          <Group
            position={loc}
            key={hex.id}
            onClick={() => selectHex(hex.id)}
            onTap={() => selectHex(hex.id)}
          >
            <Hexagon stroke={stroke} />
            <TileBG tile={hex.tile} />
            {system && <PlanetImg planet={system.type} />}
            {hasShip && <FleetImg />}
          </Group>
        );
      })}
    </Group>
  );
};

export default Galaxy;
