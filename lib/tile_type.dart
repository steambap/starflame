enum TileType {
  empty(cost: 10),
  asteroidField(cost: 20),
  nebula(cost: 25),
  gravityRift(cost: -1);

  const TileType({required this.cost});

  final int cost;
}
