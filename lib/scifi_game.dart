import 'dart:math';
import 'package:flutter/foundation.dart' show kDebugMode;

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:get_it/get_it.dart';

import "scifi_world.dart";
import "state.dart";
import 'hud_state.dart';
import "backdrop.dart";
import 'map_grid.dart';
import 'game_settings.dart';
import 'game_creator.dart';
import 'widgets/main_menu.dart';
import 'widgets/topbar.dart';

class ScifiGame extends FlameGame<ScifiWorld>
    with HasKeyboardHandlerComponents, ScrollDetector, HasTimeScale {
  final getIt = GetIt.instance;
  final MapGrid mapGrid = MapGrid();
  final rand = Random();
  final State g = State();
  late GameSettings currentGameSettings;

  ScifiGame() : super(world: ScifiWorld()) {
    getIt.registerSingleton<HudState>(HudState());
  }

  @override
  Future<void> onLoad() async {
    await images.loadAllImages();

    await world.add(mapGrid);
    camera.viewfinder.zoom = 0.75;
    camera.backdrop.add(Backdrop());
    // Start paused
    timeScale = 0;
    if (kDebugMode) {
      overlays.remove(MainMenu.id);
      startTestGame();
    }
  }

  void startTestGame() async {
    currentGameSettings = GameSettings(0);
    final gameCreator = GameCreator(this);
    gameCreator.create(currentGameSettings);

    world.isGameStarted = true;
    overlays.addAll([Topbar.id]);
    mapGrid.start(currentGameSettings);
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
