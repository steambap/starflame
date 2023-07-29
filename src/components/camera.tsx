import { useRef, useLayoutEffect, ReactNode } from "react";
import Konva from 'konva';
import { Stage, Layer } from "react-konva";
import { useSelector } from 'react-redux';
import type { RootState } from "../stores";

const Camera = ({ children }: { children: ReactNode }) => {
  const stageRef = useRef<Konva.Stage>(null);
  const cameraState = useSelector((state: RootState) => state.camera);
  useLayoutEffect(() => {
    stageRef.current?.to({
      x: (window.innerWidth / 2) - cameraState.x,
      y: (window.innerHeight / 2) - cameraState.y,
    });
  }, [cameraState.x, cameraState.y]);

  return (
    <Stage
      width={window.innerWidth}
      height={window.innerHeight}
      draggable
      ref={stageRef}
    >
      <Layer>{children}</Layer>
    </Stage>
  );
};

export default Camera;
