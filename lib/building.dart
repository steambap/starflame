import 'resource.dart';
import 'sim_props.dart';

enum BuildingType {
  mega,
  civilian,
  military,
}

class PlanetBuilding {
  final String name;
  int level;

  PlanetBuilding({
    required this.name,
    this.level = 1,
  });
}

class BuildingData with SimObject {
  static const List<double> priceMultiplier = [1, 1.5, 2];
  static const List<int> propertyMultiplier = [1, 2, 3];

  final String name;
  final Resources cost;
  final String description;

  BuildingData({
    required this.name,
    required this.cost,
    required this.description,
    Map<Property, int> obj = const {},
  }) {
    props.addAll(obj);
  }
}
