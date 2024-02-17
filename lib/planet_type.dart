enum PlanetType {
  terran(growth: 13, energy: 5, metal: 4, approval: 0, maxPopulation: 7, weight: 6, image: 'terran.png'),
  swamp(growth: 8, energy: 3, metal: 3, approval: -5, maxPopulation: 5, weight: 10, image: 'swamp.png'),
  arid(growth: 5, energy: 8, metal: 5, approval: -3, maxPopulation: 4, weight: 8, image: 'arid.png'),
  lava(growth: 2, energy: 8, metal: 3, approval: -8, maxPopulation: 2, weight: 3, image: 'lava.png'),
  barren(growth: 1, energy: 2, metal: 1, approval: -8, maxPopulation: 2, weight: 4, image: 'barren.png');

  const PlanetType({
    required this.growth,
    required this.energy,
    required this.metal,
    required this.approval,
    required this.maxPopulation,
    required this.weight,
    required this.image,
  });

  final int growth;
  final int energy;
  final int metal;
  final int approval;
  final int maxPopulation;

  /// chance to appear in random generation
  final int weight;

  final String image;
}
