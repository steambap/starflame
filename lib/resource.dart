import "sector.dart";
import 'package:flutter/foundation.dart' show immutable;

// Resources that can be stockpiled
@immutable
class Resources {
  final double maintaince;
  final double production;
  final double credit;
  final double science;

  const Resources(
      {this.maintaince = 0,
      this.production = 0,
      this.credit = 0,
      this.science = 0});

  Resources operator +(Resources other) {
    return Resources(
      maintaince: maintaince + other.maintaince,
      production: production + other.production,
      credit: credit + other.credit,
      science: science + other.science,
    );
  }

  Resources operator *(int multiplier) {
    return Resources(
      maintaince: maintaince * multiplier,
      production: production * multiplier,
      credit: credit * multiplier,
      science: science * multiplier,
    );
  }
}

// Resources that more like a status
class Capacity {
  int citizen = 0;
  SectorDataTable sectorDataTable = {};

  Capacity();

  Capacity.from({required this.sectorDataTable, required this.citizen});

  Capacity operator +(Capacity other) {
    return Capacity.from(
      citizen: citizen + other.citizen,
      sectorDataTable: {
        ...sectorDataTable,
        ...other.sectorDataTable,
      },
    );
  }
}
