import "hex.dart";

class Sector {
  String name = "";
  List<Hex> planetPosList = [];
}

class SectorData {
  int invest = 0;
}

typedef SectorDataTable = Map<Hex, SectorData>;
