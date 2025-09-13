import 'dart:math';

import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:get_it/get_it.dart';

import "scifi_world.dart";
import 'hud_state.dart';
import "backdrop.dart";
import 'map_grid.dart';

class ScifiGame extends FlameGame<ScifiWorld>
    with HasKeyboardHandlerComponents, ScrollDetector {
  final getIt = GetIt.instance;
  final MapGrid mapGrid = MapGrid();
  final rand = Random();

  ScifiGame() : super(world: ScifiWorld()) {
    getIt.registerSingleton<HudState>(HudState());
  }

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    await world.add(mapGrid);
    camera.viewfinder.zoom = 0.5;
    camera.backdrop.add(Backdrop());
    startTestGame();
  }

  void startTestGame() async {
    // final s = GameSettings(0);
    // currentGameSettings = s;
    // s.players = gameCreator.getTestPlayers(s);
    // gameCreator.create(s);

    // controller.initGame(s.players);
    world.isGameStarted = true;
    mapGrid.start('human0');
    // await mapGrid.initMap(gameCreator);
    // controller.startGame();
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
