import "hex.dart";

class Sector {
  String name = "";
  List<Hex> planetPosList = [];
}

class SectorData {
  bool hasHQ = false;

  SectorData({this.hasHQ = false});
}

typedef SectorDataTable = Map<Hex, SectorData>;
