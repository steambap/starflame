enum PlanetType {
  terran(energy: 5, growthRate: 8, weight: 10, image: 'terran.png'),
  swamp(energy: 4, growthRate: 5, weight: 6, image: 'swamp.png'),
  arid(energy: 6, growthRate: 3, weight: 8, image: 'arid.png'),
  lava(energy: 7, growthRate: 1, weight: 3, image: 'lava.png'),
  barren(energy: 3, growthRate: 0, weight: 4, image: 'barren.png');

  const PlanetType({
    required this.energy,
    required this.growthRate,
    required this.weight,
    required this.image,
  });

  /// base energy production & robotic life replicate rate
  final int energy;
  final int growthRate;

  /// chance to appear in random generation
  final int weight;
  ///
  final String image;
}

enum PlanetSize {
  small(maxPopulation: 1000000000, maxBuildings: 2),
  medium(maxPopulation: 2000000000, maxBuildings: 3),
  large(maxPopulation: 4000000000, maxBuildings: 4);

  const PlanetSize({
    required this.maxPopulation,
    required this.maxBuildings,
  });

  final int maxPopulation;
  final int maxBuildings;
}
