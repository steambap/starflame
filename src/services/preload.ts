const assets: Record<string, HTMLImageElement> = {};

const keys = [
  "asteroid",
  "nebula",
  "system",
  "ice",
  "arid",
  "lava",
  "terran",
  "swamp",
  "ship",
];

keys.forEach((key) => {
  const img = document.createElement("img");

  img.addEventListener("load", () => {
    assets[key] = img;
  });

  img.src = `/${key}.webp`;
});

export default assets;
