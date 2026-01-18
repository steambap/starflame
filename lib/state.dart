import 'cell.dart';
import "planet.dart";
import "player.dart";

class State {
  final List<List<Cell>> cells = [];
  final List<Planet> planets = [];
  final List<Player> players = [];
  int humanPlayerIdx = 0;

  Map<String, dynamic> toJson() {
    return {
      'cells': cells,
      'planets': planets,
      'players': players,
    };
  }
}
