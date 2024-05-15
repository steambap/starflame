import "sector.dart";
import 'package:flutter/foundation.dart' show immutable;

// Resources that can be stockpiled
@immutable
class Resources {
  final double food;
  final int production;
  final double credit;
  final int science;
  final int influence;

  const Resources(
      {this.food = 0,
      this.production = 0,
      this.credit = 0,
      this.science = 0,
      this.influence = 0});

  Resources operator +(Resources other) {
    return Resources(
      food: food + other.food,
      production: production + other.production,
      credit: credit + other.credit,
      science: science + other.science,
      influence: influence + other.influence,
    );
  }

  Resources operator *(int multiplier) {
    return Resources(
      food: food * multiplier,
      production: production * multiplier,
      credit: credit * multiplier,
      science: science * multiplier,
      influence: influence * multiplier,
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
