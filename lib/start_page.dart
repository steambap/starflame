import 'dart:async';

import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'styles.dart';
import 'dialog_background.dart';
import 'hud_page.dart';
import 'components/advanced_button.dart';

class StartPage extends Component with HasGameReference<ScifiGame> {
  StartPage();

  static const routeName = 'start';
  late final TextComponent _logo;
  late final AdvancedButton _button1;
  late final DialogBackground _background;

  @override
  FutureOr<void> onLoad() {
    addAll([
      _background = DialogBackground(),
      _logo = TextComponent(
        text: 'Starfury',
        textRenderer: heading24,
        anchor: Anchor.center,
      ),
      _button1 = AdvancedButton(
        size: menuButtonSize,
        anchor: Anchor.center,
        defaultSkin: RectangleComponent(paint: btnDefault),
        hoverSkin: RectangleComponent(paint: btnHover),
        defaultLabel: TextComponent(
          text: 'New Game',
          textRenderer: label16,
        ),
        hoverLabel: TextComponent(
          text: 'New Game',
          textRenderer: label16DarkGray,
        ),
        onReleased: () {
          game.router.pushReplacementNamed(HudPage.routeName);
          game.startTestGame();
        },
      ),
    ]);
    return super.onLoad();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2, size.y / 3);
    _button1.position = Vector2(size.x / 2, _logo.y + 80);
    _background.size = size;
  }
}
