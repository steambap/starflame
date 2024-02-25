enum PlanetType {
  terran(growth: 13, energy: 4, metal: 3, support: 0, maxPopulation: 7, weight: 5, image: 'terran.png'),
  ocean(growth: 10, energy: 4, metal: 2, support: 0, maxPopulation: 6, weight: 5, image: 'ocean.png'),
  swamp(growth: 8, energy: 5, metal: 1, support: -3, maxPopulation: 5, weight: 8, image: 'swamp.png'),
  arid(growth: 5, energy: 4, metal: 5, support: -3, maxPopulation: 4, weight: 7, image: 'arid.png'),
  lava(growth: 1, energy: 2, metal: 8, support: -8, maxPopulation: 2, weight: 3, image: 'lava.png'),
  ice(growth: 2, energy: 4, metal: 0, support: -5, maxPopulation: 3, weight: 5, image: 'ice.png'),
  barren(growth: 1, energy: 2, metal: 0, support: -8, maxPopulation: 2, weight: 4, image: 'barren.png');

  const PlanetType({
    required this.growth,
    required this.energy,
    required this.metal,
    required this.support,
    required this.maxPopulation,
    required this.weight,
    required this.image,
  });

  final int growth;
  final int energy;
  final int metal;
  final int support;
  final int maxPopulation;

  /// chance to appear in random generation
  final int weight;

  final String image;
}

enum ColonyType {
  none,
  militaryInstallation,
  miningBase,
  powerGrid,
  researchStation,
}
