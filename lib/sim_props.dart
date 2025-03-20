typedef Property = String;

class SimProps {
  static const Property support = 'support';
  static const Property production = 'production';
  static const Property credit = 'credit';
  static const Property science = 'science';
  // Ship
  static const Property hull = 'hull';
  static const Property energy = 'energy';
  static const Property energyUpkeep = 'energyUpkeep';
  static const Property movement = 'movement';
  static const Property computers = 'computers';
  static const Property allowLockon = 'allowLockon';
  static const Property countermeasures = 'countermeasures';
  static const Property shield = 'shield';
  static const Property cannon = 'cannon';
  static const Property missile = 'missile';
}

mixin SimObject {
  final Map<Property, int> props = {};

  int getProp(Property prop) => props[prop] ?? 0;

  void addProp(Property prop, int value) {
    props.update(prop, (prev) => prev + value, ifAbsent: () => value);
  }
}
