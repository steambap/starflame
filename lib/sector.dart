import "hex.dart";

class Sector {
  String name = "";
  List<Hex> planetPosList = [];
}

class SectorData {
  bool hasHQ = false;
}

typedef SectorDataTable = Map<Hex, SectorData>;
