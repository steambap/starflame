import 'resource.dart';
import 'sim_props.dart';

enum BuildingType {
  mega,
  civilian,
  military,
}

class Building {
  final String name;
  int level;

  Building({
    required this.name,
    this.level = 1,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "level": level,
    };
  }

  factory Building.fromJson(Map<String, dynamic> json) {
    return Building(
      name: json['name'] as String,
      level: json['level'] as int,
    );
  }
}

class BuildingData with SimObject {
  static const List<double> priceMultiplier = [1, 1.5, 2];
  static const List<int> propertyMultiplier = [1, 2, 3];

  final String name;
  final BuildingType bType;
  final bool isUnique;
  final bool noMaintenance;
  final bool noUpgrade;
  final Resources cost;
  final String description;

  BuildingData({
    required this.name,
    required this.bType,
    this.isUnique = false,
    this.noMaintenance = false,
    required this.noUpgrade,
    required this.cost,
    required this.description,
    Map<Property, int> obj = const {},
  }) {
    props.addAll(obj);
  }

  int costOf(int level) {
    if (level < 1 || level > priceMultiplier.length) {
      throw ArgumentError(
          "Level must be between 1 and ${priceMultiplier.length}");
    }
    return (cost.production * priceMultiplier[level - 1]).toInt();
  }

  int maintenanceOf(int level) {
    if (noMaintenance) {
      return 0;
    }

    return level;
  }
}
