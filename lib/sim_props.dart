typedef Property = String;

class SimProps {
  static const Property energy = 'energy';
  static const Property production = 'production';
  static const Property civic = 'civic';
  // Ship
  static const Property maxHealth = 'maxHealth';
  static const Property energyUpkeep = 'energyUpkeep';
  static const Property movement = 'movement';
  static const Property strength = 'strength';
  static const Property rangedStrength = 'rangedStrength';
  static const Property allowRanged = 'allowRanged';
  static const Property engineering = 'engineering';
  static const Property maxMorale = 'maxMorale';
}

mixin SimObject {
  final Map<Property, int> props = {};

  int getProp(Property prop) => props[prop] ?? 0;

  void addProp(Property prop, int value) {
    props.update(prop, (prev) => prev + value, ifAbsent: () => value);
  }
}
