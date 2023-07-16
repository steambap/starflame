import { Hex, Loc } from "../types/hex";
import { qMax, hexSize } from "../data/constants";

function from(q: number, r: number, s: number): Hex {
  if (q + r + s !== 0) {
    throw new Error("not a hex");
  }

  return { q, r, s };
}

function add(a: Hex, b: Hex): Hex {
  return {
    q: a.q + b.q,
    r: a.r + b.r,
    s: a.s + b.s,
  };
}

function sub(a: Hex, b: Hex): Hex {
  return {
    q: a.q - b.q,
    r: a.r - b.r,
    s: a.s - b.s,
  };
}

function eq(a: Hex, b: Hex) {
  return a.q === b.q && a.r === b.r && a.s === b.s;
}

function distance(a: Hex, b: Hex): number {
  const hex = sub(a, b);

  return (Math.abs(hex.q) + Math.abs(hex.r) + Math.abs(hex.s)) / 2;
}

function toPixel(h: Hex): Loc {
  const x: number =
    (Math.sqrt(3.0) * h.q + (Math.sqrt(3.0) / 2.0) * h.r) * hexSize;
  const y: number = (3.0 / 2.0) * h.r * hexSize;

  return { x, y };
}

function polygonCorners(h: Hex): Loc[] {
  const corners: Loc[] = [];
  const center = toPixel(h);
  for (let i = 0; i < 6; i++) {
    const angle = (2.0 * Math.PI * (i + 0.5)) / 6.0;
    const x = Math.cos(angle) * hexSize + center.x;
    const y = Math.sin(angle) * hexSize + center.y;

    corners.push({ x, y });
  }

  return corners;
}

export const hexDirections = [
  from(1, 0, -1), // E
  from(1, -1, 0), // NE
  from(0, -1, 1), // NW
  from(-1, 0, 1), // W
  from(-1, 1, 0), // SW
  from(0, 1, -1), // SE
];

export const hexOrigin = from(0, 0, 0);

function toStr(h: Hex): string {
  return `${h.q},${h.r},${h.s}`;
}

export const hexMap: Hex[] = [];
for (let q = -qMax; q <= qMax; q++) {
  let r1 = Math.max(-qMax, -q - qMax);
  let r2 = Math.min(qMax, -q + qMax);
  for (let r = r1; r <= r2; r++) {
    hexMap.push(from(q, r, -q - r));
  }
}

function isMapCorner(h: Hex) {
  if (h.q === 0 || h.r === 0 || h.s === 0) {
    if (
      Math.abs(h.q) === qMax ||
      Math.abs(h.r) === qMax ||
      Math.abs(h.s) === qMax
    ) {
      return true;
    }
  }

  return false;
}

export const HexService = {
  from,
  add,
  sub,
  eq,
  distance,
  toPixel,
  polygonCorners,
  toStr,
  isMapCorner,
};
