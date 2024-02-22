enum FacilityType {
  metalExtractor,
  fusionReactor,
  monolith,
  metalScanner,
  radioactiveCollider,
  computerComplex,
  medicalLab,
  climateControlDevice,
}

class Facility {
  final FacilityType type;
  int level;

  Facility(this.type, {this.level = 1});
}
