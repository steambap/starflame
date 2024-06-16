enum PlanetClimate {
  temperate,
  hot,
  cold,
}

enum PlanetType {
  terran(
      food: 8,
      production: 3,
      credit: 4,
      science: 4,
      climate: PlanetClimate.temperate,
      weight: 5,
      image: 'terran.png'),
  ocean(
      food: 7,
      production: 2,
      credit: 4,
      science: 6,
      climate: PlanetClimate.temperate,
      weight: 5,
      image: 'ocean.png'),
  swamp(
      food: 5,
      production: 2,
      credit: 8,
      science: 2,
      climate: PlanetClimate.temperate,
      weight: 8,
      image: 'swamp.png'),
  arid(
      food: 2,
      production: 8,
      credit: 4,
      science: 0,
      climate: PlanetClimate.hot,
      weight: 7,
      image: 'arid.png'),
  lava(
      food: 0,
      production: 16,
      credit: 2,
      science: 0,
      climate: PlanetClimate.hot,
      weight: 3,
      image: 'lava.png'),
  ice(
      food: 2,
      production: 0,
      credit: 4,
      science: 8,
      climate: PlanetClimate.cold,
      weight: 5,
      image: 'ice.png'),
  barren(
      food: 0,
      production: 0,
      credit: 2,
      science: 16,
      climate: PlanetClimate.cold,
      weight: 4,
      image: 'barren.png');

  const PlanetType({
    required this.food,
    required this.production,
    required this.credit,
    required this.science,
    required this.climate,
    required this.weight,
    required this.image,
  });

  final int food;
  final int production;
  final int credit;
  final int science;
  final PlanetClimate climate;

  /// chance to appear in random generation
  final int weight;

  final String image;
}
