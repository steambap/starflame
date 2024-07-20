import "sim_props.dart";

enum TechSection {
  military,
  grid,
  nano,
  rare,
}

class Research {
  final String id;
  final String displayName;
  final String description;
  final TechSection section;
  final int cost;
  final Map<Property, double> effects;
  final String image;

  Research({
    required this.id,
    required this.displayName,
    this.description = "",
    required this.section,
    required this.cost,
    required this.effects,
    required this.image,
  });
}
