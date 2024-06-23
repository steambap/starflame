typedef Property = String;

class SimProps {
  static const Property production = 'production';
  static const Property credit = 'credit';
  static const Property science = 'science';
  static const Property maintainceCost = 'maintainceCost';
}

mixin SimObject {
  final Map<Property, double> props = {};

  double getProp(Property prop) => props[prop] ?? 0;

  void addProp(Property prop, double value) {
    props.update(prop, (prev) => prev + value, ifAbsent: () => value);
  }
}
