import 'cell.dart';
import "planet.dart";
import "player.dart";

class State {
  final List<List<Cell>> cells = [];
  final List<Planet> planets = [];
  final List<Player> players = [];
  int humanPlayerIdx = 0;
  int turn = 0;
  int moveOrderTurn = 0;

  Map<String, dynamic> toJson() {
    return {
      'cells': cells,
      'planets': planets,
      'players': players,
      'humanPlayerIdx': humanPlayerIdx,
      'turn': turn,
      'moveOrderTurn': moveOrderTurn,
    };
  }
}
