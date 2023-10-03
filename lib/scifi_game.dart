import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'game_creator.dart';
import 'map_grid.dart';

class ScifiGame extends FlameGame with HasKeyboardHandlerComponents {
  final MapGrid mapGrid = MapGrid();
  final GameCreator gameCreator = GameCreator();

  ScifiGame();

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    world.add(mapGrid);
  }
}
