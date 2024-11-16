import "sim_props.dart";

class Research {
  final String id;
  final String displayName;
  final String description;
  final TechSection section;
  final int tier;
  final int cost;
  final Map<Property, int> effects;
  final String image;

  Research({
    required this.id,
    required this.displayName,
    this.description = "",
    required this.section,
    required this.tier,
    required this.cost,
    required this.effects,
    this.image = "",
  });
}

enum TechSection {
  warfare,
  construction,
  nano,
}
