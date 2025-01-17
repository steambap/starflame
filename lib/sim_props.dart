typedef Property = String;

class SimProps {
  static const Property neutronBombs = 'neutronBombs';
  static const Property allowIonMissile = 'allowIonMissile';
  static const Property neutronDefense = 'neutronDefense';
  static const Property starbaseFreeUpdate = 'starbaseFreeUpdate';
  static const Property starbaseInitiative = 'starbaseInitiative';
  static const Property allowImprovedHull = 'allowImprovedHull';
  static const Property allowSentientHull = 'allowSentientHull';
  static const Property allowAbsorptionShield = 'allowAbsorptionShield';
  static const Property moveCostAsteroid = 'moveCostAsteroid';
  static const Property allowFusionSource = 'allowFusionSource';
  static const Property allowFusionDrive = 'allowFusionDrive';
  static const Property allowTerraforming = 'allowTerraforming';
  static const Property allowAdvancedSlot = 'allowAdvancedSlot';
  static const Property allowTachyonSource = 'allowTachyonSource';
  static const Property allowTachyonDrive = 'allowTachyonDrive';
  static const Property allowElectronCountermeasures = 'allowElectronCountermeasures';

  static const Property support = 'support';
  static const Property production = 'production';
  static const Property credit = 'credit';
  static const Property science = 'science';
  // Ship
  static const Property hull = 'hull';
  static const Property energy = 'energy';
  static const Property movement = 'movement';
  static const Property isFTL = 'isFTL';
  static const Property initiative = 'initiative';
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
