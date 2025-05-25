typedef Property = String;

class SimProps {
  static const Property energy = 'energy';
  static const Property production = 'production';
  static const Property politics = 'politics';
  static const Property influence = 'influence';
  // Ship
  static const Property maxHealth = 'maxHealth';
  static const Property energyUpkeep = 'energyUpkeep';
  static const Property movement = 'movement';
  static const Property strength = 'strength';
  static const Property rangedStrength = 'rangedStrength';
  static const Property allowRanged = 'allowRanged';
  static const Property engineering = 'engineering';
  static const Property maxMorale = 'maxMorale';
  // policy
  static const Property hqBuildingInfluence = 'hqBuildingInfluence';
  static const Property hqBuildingPolitic = 'hqBuildingPolitic';
  static const Property reformTry = 'reformTry';
  static const Property minimumActionPoints = 'minimumActionPoints';
  static const Property politicsPerUnit = 'politicsPerUnit';
  static const Property trainTry = 'trainTry';
  static const Property influenceToPolitics = 'influenceToPolitics';
  static const Property allyInfluence = 'allyInfluence';
  static const Property antiCorruption = 'antiCorruption';
  static const Property diplomaticTry = 'diplomaticTry';
  static const Property resourceToInfluence = 'resourceToInfluence';
  static const Property alwaysAlive = 'alwaysAlive';
}

mixin SimObject {
  final Map<Property, int> props = {};

  int getProp(Property prop) => props[prop] ?? 0;

  void addProp(Property prop, int value) {
    props.update(prop, (prev) => prev + value, ifAbsent: () => value);
  }
}
