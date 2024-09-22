import "sim_props.dart";

class Research {
  final String id;
  final int category;
  final String displayName;
  final String description;
  final TechSection section;
  final int cost;
  final Map<Property, int> effects;
  final String image;

  Research({
    required this.id,
    required this.category,
    required this.displayName,
    this.description = "",
    required this.section,
    required this.cost,
    required this.effects,
    required this.image,
  });
}

enum TechSection {
  military,
  grid,
  nano,
  rare,
}
