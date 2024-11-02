import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'scifi_game.dart';
import 'styles.dart';
import 'widgets/main_menu.dart';
import 'widgets/in_game_menu.dart';
import 'widgets/player_info.dart';
import 'widgets/action_bar.dart';
import 'widgets/ship_cmd.dart';
import 'widgets/sector_info.dart';
import 'widgets/hud_menu_button.dart';
import 'widgets/sector_overlay.dart';
import 'widgets/map_deploy.dart';
import 'widgets/victory_overlay.dart';

class ScifiApp extends StatelessWidget {
  const ScifiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Starflame',
        theme: ThemeData(
          fontFamily: 'Chakra',
          visualDensity: VisualDensity.adaptivePlatformDensity,
          dialogTheme: AppTheme.dialogTheme,
        ),
        home: Scaffold(
          body: GameWidget<ScifiGame>.controlled(
            loadingBuilder: (context) => const Center(
              child: SizedBox(
                width: 200,
                child: LinearProgressIndicator(),
              ),
            ),
            overlayBuilderMap: {
              MapDeploy.id: (_, game) => MapDeploy(game),
              ActionBar.id: (_, game) => ActionBar(game),
              HudMenuButton.id: (_, game) => HudMenuButton(game),
              SectorInfo.id: (_, game) => SectorInfo(game),
              ShipCmd.id: (_, game) => ShipCmd(game),
              SectorOverlay.id: (_, game) => SectorOverlay(game),
              PlayerInfoBar.id: (_, game) => PlayerInfoBar(game),
              VictoryOverlay.id: (_, game) => VictoryOverlay(game),
              InGameMenu.id: (_, game) => InGameMenu(game),
              MainMenu.id: (_, game) => MainMenu(game),
            },
            initialActiveOverlays: const [
              ActionBar.id,
              HudMenuButton.id,
              SectorInfo.id,
              ShipCmd.id,
              PlayerInfoBar.id
            ],
            gameFactory: () => ScifiGame(),
          ),
        ));
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(const ScifiApp());
}
