import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:get_it/get_it.dart';

import "scifi_world.dart";
import 'hud_state.dart';
import 'game_state_controller.dart';
import 'game_creator.dart';
import 'map_grid.dart';
import "game_settings.dart";
import "resource_controller.dart";
import 'hud_page.dart';
import "ai/ai_controller.dart";
import "combat_resolver.dart";
import "animation_pool.dart";
import "backdrop.dart";

class ScifiGame extends FlameGame<ScifiWorld>
    with HasKeyboardHandlerComponents, ScrollDetector {
  final MapGrid mapGrid = MapGrid();
  final GameCreator gameCreator = GameCreator();
  late GameSettings currentGameSettings;
  late final GameStateController controller;
  late final ResourceController resourceController;
  late final AIController aiController;
  late final CombatResolver combatResolver = CombatResolver(this);
  late final AnimationPool animationPool = AnimationPool(this);
  final getIt = GetIt.instance;
  final HudPage hud = HudPage();
  late final RouterComponent router = RouterComponent(
    routes: {
      HudPage.routeName: Route(() => hud),
    },
    initialRoute: HudPage.routeName,
  );

  ScifiGame() : super(world: ScifiWorld()) {
    controller = GameStateController(this);
    resourceController = ResourceController(this);
    aiController = AIController(this);
    getIt.registerSingleton<HudState>(HudState());
  }

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    await world.add(mapGrid);
    camera.viewfinder.zoom = 0.5;
    camera.viewport.add(router);
    camera.backdrop.add(Backdrop());
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

  void clampZoom() {
    camera.viewfinder.zoom = camera.viewfinder.zoom.clamp(0.5, 1.0);
  }

  static const zoomPerScrollUnit = 0.02;

  @override
  void onScroll(PointerScrollInfo info) {
    camera.viewfinder.zoom -=
        info.scrollDelta.global.y.sign * zoomPerScrollUnit;
    clampZoom();
  }
}
