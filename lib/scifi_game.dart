import 'package:flame/events.dart';
import 'package:flame/game.dart';

import 'hud_next_turn_btn.dart';
import 'hud_player_info.dart';
import 'game_state_controller.dart';
import 'game_creator.dart';
import 'map_grid.dart';
import "game_settings.dart";
import "resource_controller.dart";

class ScifiGame extends FlameGame with HasKeyboardHandlerComponents {
  final MapGrid mapGrid = MapGrid();
  final GameCreator gameCreator = GameCreator();
  late final GameStateController gameStateController;
  late final ResourceController resourceController;
  final HudPlayerInfo playerInfo = HudPlayerInfo();
  final HudNextTurnBtn nextTurnBtn = HudNextTurnBtn();

  ScifiGame() {
    gameStateController = GameStateController(this);
    resourceController = ResourceController(this);
  }

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    await world.add(mapGrid);

    camera.viewport.add(playerInfo);
    camera.viewport.add(nextTurnBtn);

    final s = GameSettings(0);
    s.players = gameCreator.getTestPlayers(s);
    final cells = gameCreator.create(s);
    mapGrid.initMap(cells);

    gameStateController.startGame(s.players);
  }
}
