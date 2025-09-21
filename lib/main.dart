import 'package:flame/game.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

import 'scifi_game.dart';
import 'styles.dart';
import 'widgets/main_menu.dart';

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
          tabBarTheme: AppTheme.tabTheme,
        ),
        home: Scaffold(
          body: GameWidget<ScifiGame>.controlled(
            loadingBuilder: (context) => Container(
              color: AppTheme.dialogBackground,
              child: const Center(
                child: Column(
                  spacing: 16,
                  children: [
                    Text('Loading...', style: AppTheme.heading24),
                    SizedBox(
                      width: 360,
                      child: LinearProgressIndicator(),
                    ),
                  ],
                ),
              ),
            ),
            overlayBuilderMap: {
              MainMenu.id: (_, game) => MainMenu(game),
            },
            initialActiveOverlays: MainMenu.initialOverlays,
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
