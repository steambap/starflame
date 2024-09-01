import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'styles.dart'
    show heading24, label16, label16DarkGray, btnDefault, btnHover;
import 'dialog_background.dart';
import 'hud_page.dart';
import 'components/advanced_button.dart';

class StartPage extends Component with HasGameReference<ScifiGame> {
  static final buttonSize = Vector2(160, 32);
  StartPage() {
    addAll([
      _background = DialogBackground(),
      _logo = TextComponent(
        text: 'Starfury',
        textRenderer: heading24,
        anchor: Anchor.center,
      ),
      _button1 = AdvancedButton(
        size: buttonSize,
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
        onPressed: () {
          game.router.pushReplacementNamed(HudPage.routeName);
          game.startTestGame();
        },
      ),
    ]);
  }

  static const routeName = 'start';
  late final TextComponent _logo;
  late final AdvancedButton _button1;
  late final DialogBackground _background;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2, size.y / 3);
    _button1.position = Vector2(size.x / 2, _logo.y + 80);
    _background.size = size;
  }
}
