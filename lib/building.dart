import "sim_props.dart";

enum Building {
  colonyHQ(
      cost: 150,
      uniqueTag: 'unique',
      displayName: "Colony Base",
      image: 'colony_hq.png'),

  constructionYard(
      cost: 54,
      displayName: "Construction Yard",
      image: 'construction_yard.png'),
  bank(cost: 60, displayName: "Bank", image: 'bank.png'),
  lab(
      cost: 54,
      displayName: "Research Lab",
      image: 'lab.png',
      uniqueTag: 'lab');

  const Building({
    required this.cost,
    this.uniqueTag = "",
    required this.displayName,
    required this.image,
  });

  final int cost;
  final String uniqueTag;
  final String displayName;

  final String image;
}

class BuildingData with SimObject {
  final Building building;

  BuildingData(this.building, Map<Property, double> data) {
    data.forEach((key, value) {
      addProp(key, value);
    });
  }
}
