import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'scifi_game.dart';
import 'styles.dart';
import 'widgets/main_menu.dart';
import 'widgets/topbar.dart';
import 'widgets/hud_bottom_right.dart';

class ScifiApp extends StatelessWidget {
  const ScifiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Starflame',
      theme: ThemeData(
        fontFamily: 'Chakra',
        visualDensity: .adaptivePlatformDensity,
        dialogTheme: AppTheme.dialogTheme,
        tabBarTheme: AppTheme.tabTheme,
        textTheme: AppTheme.textTheme,
        textButtonTheme: AppTheme.textButtonTheme,
      ),
      home: Scaffold(
        body: GameWidget<ScifiGame>.controlled(
          loadingBuilder: (context) => Container(
            color: AppTheme.dialogBackground,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 8),
            child: const Center(
              child: Column(
                children: [
                  Text('Loading...', style: AppTheme.heading24),
                  SizedBox(width: 360, child: LinearProgressIndicator()),
                ],
              ),
            ),
          ),
          overlayBuilderMap: {
            MainMenu.id: (_, game) => MainMenu(game),
            Topbar.id: (_, game) => Topbar(game),
            HudBottomRight.id: (_, game) => HudBottomRight(game),
          },
          initialActiveOverlays: MainMenu.initialOverlays,
          gameFactory: () => ScifiGame(),
        ),
      ),
    );
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flame.device.fullScreen();
  Flame.device.setLandscape();

  runApp(const ScifiApp());
}
