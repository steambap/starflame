import "sector.dart";

// Resources that can be stockpiled
class Resources {
  int production;
  double credit;

  Resources({this.production = 0, this.credit = 0});

  Resources operator +(Resources other) {
    return Resources(
      production: production + other.production,
      credit: credit + other.credit,
    );
  }
}

// Resources that more like a status
class Capacity {
  int influence = 0;
  SectorDataTable sectorDataTable = {};

  Capacity();

  Capacity.from({required this.influence, required this.sectorDataTable});

  Capacity operator +(Capacity other) {
    return Capacity.from(
      influence: influence + other.influence,
      sectorDataTable: {
        ...sectorDataTable,
        ...other.sectorDataTable,
      },
    );
  }
}
