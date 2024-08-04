import 'package:flame/components.dart';

import 'scifi_game.dart';
import 'theme.dart' show heading24, label16, btnDefaultSkin, btnHoverSkin;
import 'dialog_background.dart';
import 'hud_page.dart';
import './components/cut_out_rect.dart';

class StartPage extends Component with HasGameReference<ScifiGame> {
  StartPage() {
    addAll([
      _background = DialogBackground(),
      _logo = TextComponent(
        text: 'Starfury',
        textRenderer: heading24,
        anchor: Anchor.center,
      ),
      _button1 = AdvancedButtonComponent(
        size: Vector2(160, 32),
        anchor: Anchor.center,
        defaultSkin: CutOutRect(paintLayers: btnDefaultSkin),
        hoverSkin: CutOutRect(paintLayers: btnHoverSkin),
        defaultLabel: TextComponent(
          text: 'New Game',
          textRenderer: label16,
          anchor: Anchor.center,
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
  late final AdvancedButtonComponent _button1;
  late final DialogBackground _background;

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    _logo.position = Vector2(size.x / 2, size.y / 3);
    _button1.position = Vector2(size.x / 2, _logo.y + 80);
    _background.size = size;
  }
}
