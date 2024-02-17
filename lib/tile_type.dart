enum TileType {
  empty(cost: 1),
  asteroidField(cost: 2),
  nebula(cost: 3),
  gravityRift(cost: -1),
  alphaWormHole(cost: 1),
  betaWormHole(cost: 1);

  const TileType({required this.cost});

  final int cost;
}
