import "../ship_hull.dart";

final List<ShipHull> hulls = [
  ShipHull(
    movement: 20,
    strength: 20,
    rangedStrength: 0,
    range: 0,
    pointDefense: 4,
    type: ShipType.screen,
    cost: 100,
    name: 'Frigate',
    image: 'ships/screen.png',
  ),
  ShipHull(
    movement: 20,
    strength: 25,
    rangedStrength: 0,
    range: 0,
    pointDefense: 0,
    type: ShipType.capital,
    cost: 100,
    name: 'Battlecruiser',
    image: 'ships/capital.png',
  ),
  ShipHull(
    movement: 20,
    strength: 15,
    rangedStrength: 20,
    range: 2,
    pointDefense: 0,
    type: ShipType.carrier,
    cost: 100,
    name: 'Light Carrier',
    image: 'ships/carrier.png',
  ),
  ShipHull(
    movement: 50,
    strength: 15,
    rangedStrength: 0,
    range: 0,
    pointDefense: 0,
    type: ShipType.raider,
    cost: 100,
    name: 'Scout',
    image: 'ships/raider.png',
  ),
];

final Map<String, ShipHull> hullMap =
    Map.fromEntries(hulls.map((hull) => MapEntry(hull.name, hull)));
