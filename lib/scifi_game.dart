import 'package:flame/events.dart';
import 'package:flame/game.dart';

import "scifi_world.dart";
import 'hud_bottom_right.dart';
import "hud_menu_button.dart";
import 'hud_player_info.dart';
import 'game_state_controller.dart';
import 'game_creator.dart';
import 'map_grid.dart';
import "game_settings.dart";
import "resource_controller.dart";
import 'hud_ship_cmd.dart';
import "hud_sector_info.dart";
import "start_page.dart";
import 'hud_page.dart';
import "ai/ai_controller.dart";
import "combat_resolver.dart";
import "hud_map_deploy.dart";
import "animation_pool.dart";

class ScifiGame extends FlameGame<ScifiWorld>
    with HasKeyboardHandlerComponents {
  final MapGrid mapGrid = MapGrid();
  final GameCreator gameCreator = GameCreator();
  late GameSettings currentGameSettings;
  late final GameStateController controller;
  late final ResourceController resourceController;
  late final AIController aiController;
  late final CombatResolver combatResolver = CombatResolver(this);
  late final AnimationPool animationPool = AnimationPool(this);
  final HudPlayerInfo playerInfo = HudPlayerInfo();
  final HudMenuButton menuButton = HudMenuButton();
  final HudBottomRight bottomRight = HudBottomRight();
  final HudSectorInfo sectorInfo = HudSectorInfo();
  final HudMapDeploy hudMapDeploy = HudMapDeploy();
  final HudShipCommand shipCommand = HudShipCommand();
  final HudPage hud = HudPage();
  late final RouterComponent router = RouterComponent(
    routes: {
      HudPage.routeName: Route(() => hud),
      StartPage.routeName: Route(StartPage.new),
    },
    initialRoute: HudPage.routeName,
  );

  ScifiGame() : super(world: ScifiWorld()) {
    controller = GameStateController(this);
    resourceController = ResourceController(this);
    aiController = AIController(this);
  }

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    await world.add(mapGrid);
    await hud.addAll([
      playerInfo,
      menuButton,
      bottomRight,
      sectorInfo,
      shipCommand,
      hudMapDeploy,
    ]);
    camera.viewport.add(router);
  }

  void startTestGame() async {
    final s = GameSettings(0);
    currentGameSettings = s;
    s.players = gameCreator.getTestPlayers(s);
    gameCreator.create(s);

    controller.initGame(s.players);
    await mapGrid.initMap(gameCreator);
    controller.startGame();
  }
}
