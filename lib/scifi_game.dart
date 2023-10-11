import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'hud_player_info.dart';
import 'bottom_tabs.dart';
import 'game_state_controller.dart';
import 'game_creator.dart';
import 'map_grid.dart';

class ScifiGame extends FlameGame with HasKeyboardHandlerComponents {
  final MapGrid mapGrid = MapGrid();
  final GameCreator gameCreator = GameCreator();
  late final GameStateController gameStateController;
  final HudBottomTabs bottomTabs = HudBottomTabs();
  final HudPlayerInfo playerInfo = HudPlayerInfo();

  ScifiGame() {
    gameStateController = GameStateController(this);
  }

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    await world.add(mapGrid);

    camera.viewport.add(bottomTabs);
    camera.viewport.add(playerInfo);

    final (cells, players) = gameCreator.createTutorial();
    mapGrid.initMap(cells);

    gameStateController.startGame(players);
  }
}
