typedef Property = String;

class SimProps {
  static const Property allowFusionSource = 'allowFusionSource';
  static const Property allowFusionDrive = 'allowFusionDrive';
  static const Property allowTachyonSource = 'allowTachyonSource';
  static const Property allowTachyonDrive = 'allowTachyonDrive';

  static const Property production = 'production';
  static const Property credit = 'credit';
  static const Property science = 'science';
}

mixin SimObject {
  final Map<Property, int> props = {};

  int getProp(Property prop) => props[prop] ?? 0;

  void addProp(Property prop, int value) {
    props.update(prop, (prev) => prev + value, ifAbsent: () => value);
  }
}
