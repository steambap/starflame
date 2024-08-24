import "../ship_hull.dart";

final List<ShipHull> hulls = [
  ShipHull(
    movement: 20,
    strength: 20,
    type: ShipType.screen,
    cost: 5,
    name: 'Cruiser',
    image: 'ships/screen.png',
  ),
  ShipHull(
    movement: 20,
    strength: 25,
    type: ShipType.capital,
    cost: 8,
    name: 'Dreadnought',
    image: 'ships/capital.png',
  ),
  ShipHull(
    movement: 20,
    strength: 15,
    type: ShipType.carrier,
    cost: 8,
    name: 'Carrier',
    image: 'ships/carrier.png',
  ),
  ShipHull(
    movement: 20,
    strength: 15,
    type: ShipType.raider,
    cost: 3,
    name: 'Interceptor',
    image: 'ships/raider.png',
  ),
];

final Map<String, ShipHull> hullMap =
    Map.fromEntries(hulls.map((hull) => MapEntry(hull.name, hull)));
