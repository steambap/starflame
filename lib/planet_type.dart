enum PlanetType {
  terran(energy: 5, growthRate: 8, weight: 10),
  swamp(energy: 4, growthRate: 5, weight: 6),
  arid(energy: 6, growthRate: 3, weight: 8),
  lava(energy: 7, growthRate: 1, weight: 3),
  ice(energy: 3, growthRate: 0, weight: 4);

  const PlanetType({
    required this.energy,
    required this.growthRate,
    required this.weight,
  });
  /// base energy production & robotic life replicate rate
  final int energy;
  final int growthRate;
  /// chance to appear in random generation
  final int weight;
}
