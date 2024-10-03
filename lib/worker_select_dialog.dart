import "package:flame/game.dart";
import "package:flame/components.dart";

import "planet.dart";
import "dialog_background.dart";
import "scifi_game.dart";
import "styles.dart";

import "components/advanced_button.dart";
import "components/col_container.dart";

class WorkerSelectDialog extends ValueRoute<WorkerType>
    with HasGameRef<ScifiGame> {
  final String text;

  late final _prompt = TextComponent(
    text: text,
    textRenderer: heading20,
    anchor: Anchor.center,
  );
  final _col = ColContainer(marginBottom: 8);

  WorkerSelectDialog(
    {
    this.text = "Select worker type",
  }) : super(value: WorkerType.economy);

  @override
  Component build() {
    final buttons = WorkerType.values.map((type) => AdvancedButton(
          size: menuButtonSize,
          anchor: Anchor.center,
          defaultSkin: RectangleComponent(paint: btnDefault),
          hoverSkin: RectangleComponent(paint: btnHover),
          defaultLabel: TextComponent(
            text: type.name,
            textRenderer: label16,
          ),
          hoverLabel: TextComponent(
            text: type.name,
            textRenderer: label16DarkGray,
          ),
          onReleased: () {
            completeWith(type);
          },
        ));
    _col.addAll(buttons);
    return DialogBackground(
      size: game.size,
      children: [
        _prompt,
        _col,
      ],
    );
  }

  @override
  void onGameResize(Vector2 size) {
    _prompt.position = Vector2(size.x / 2, size.y / 3);
    _col.layout();
    _col.position = Vector2(size.x / 2, _prompt.y + 80);
    super.onGameResize(size);
  }
}
