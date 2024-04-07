enum PlanetClimate {
  temperate,
  hot,
  cold,
}

enum PlanetType {
  terran(food: 80, production: 6, climate: PlanetClimate.temperate, lifeQuality: 10, weight: 5, image: 'terran.png'),
  ocean(food: 70, production: 4, climate: PlanetClimate.temperate, lifeQuality: 5, weight: 5, image: 'ocean.png'),
  swamp(food: 60, production: 3, climate: PlanetClimate.temperate, lifeQuality: 0, weight: 8, image: 'swamp.png'),
  arid(food: 40, production: 8, climate: PlanetClimate.hot, lifeQuality: 0, weight: 7, image: 'arid.png'),
  lava(food: 20, production: 13, climate: PlanetClimate.hot, lifeQuality: -5, weight: 3, image: 'lava.png'),
  ice(food: 20, production: 2, climate: PlanetClimate.cold, lifeQuality: -5, weight: 5, image: 'ice.png'),
  barren(food: 10, production: 0, climate: PlanetClimate.cold, lifeQuality: -10, weight: 4, image: 'barren.png');

  const PlanetType({
    required this.food,
    required this.production,
    required this.climate,
    required this.lifeQuality,
    required this.weight,
    required this.image,
  });

  final int food;
  final int production;
  final PlanetClimate climate;
  final int lifeQuality;
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
