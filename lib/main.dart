import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'scifi_game.dart';
import 'widgets/main_menu.dart';
import 'widgets/in_game_menu.dart';
import 'widgets/player_info.dart';
import 'widgets/action_bar.dart';
import 'widgets/ship_cmd.dart';

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
              ActionBar.id: (_, game) => ActionBar(game),
              ShipCmd.id: (_, game) => ShipCmd(game),
              PlayerInfoBar.id: (_, game) => PlayerInfoBar(game),
              InGameMenu.id: (_, game) => InGameMenu(game),
              MainMenu.id: (_, game) => MainMenu(game),
            },
            initialActiveOverlays: const [
              ActionBar.id,
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
