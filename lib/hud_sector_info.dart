import 'package:flame/components.dart';
import 'package:flame/events.dart';

import "sim_props.dart";
import "scifi_game.dart";
import "sector.dart";
import "async_updated_ui.dart";
import "theme.dart" show text12, text16;

class HudSectorInfo extends PositionComponent
    with HasGameRef<ScifiGame>, HasVisibility, DragCallbacks, AsyncUpdatedUi {
  Sector? sector;
  // Scrollable on mobile
  final _clip = ClipComponent.rectangle(
    position: Vector2(8, 44),
  );
  double scrollBoundsY = 0.0;
  final _clippedContent = PositionComponent();

  late final SpriteComponent _infoBackground;
  // Basic info
  final _sectorName = TextComponent(
      textRenderer: text16, anchor: Anchor.topLeft, position: Vector2.all(4));
  final _line1Label = TextComponent(
      text: "Production",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 40));
  final _line1Value = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 40));
  final _line2Label = TextComponent(
      text: "Credit",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 68));
  final _line2Value = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 68));
  final _line3Label = TextComponent(
      text: "Science",
      textRenderer: text12,
      anchor: Anchor.centerLeft,
      position: Vector2(8, 96));
  final _line3Value = TextComponent(
      text: "0",
      textRenderer: text12,
      anchor: Anchor.centerRight,
      position: Vector2(192, 96));

  HudSectorInfo() : super(anchor: Anchor.topLeft);

  @override
  Future<void> onLoad() async {
    size = Vector2(200, game.size.y - 40);
    _clip.size = size;
    isVisible = false;

    final bgImg = game.images.fromCache("planet_info.png");
    _infoBackground = SpriteComponent(sprite: Sprite(bgImg));

    add(_clip);
    _clip.add(_clippedContent);
    _clippedContent.addAll([
      _infoBackground,
      _sectorName,
      _line1Label,
      _line1Value,
      _line2Label,
      _line2Value,
      _line3Label,
      _line3Value,
    ]);
  }

  @override
  bool containsLocalPoint(Vector2 point) {
    if (isVisible) {
      return super.containsLocalPoint(point);
    }

    return false;
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    if (scrollBoundsY < 0) {
      _clippedContent.y += event.localDelta.y;
      _clippedContent.y = _clippedContent.y.clamp(scrollBoundsY, 0);
    }
  }

  void hide() {
    isVisible = false;
  }

  void show(Sector? sector) {
    if (sector == null) {
      return;
    }
    isVisible = true;
    _setText(sector);
    _calcScrollBounds();
    _clippedContent.y = 0;
  }

  @override
  void updateRender() {
    if (sector == null) {
      return;
    }
    _setText(sector!);
  }

  void _setText(Sector sector) {
    _sectorName.text = sector.displayName;
    _line1Value.text = "${sector.getProp(SimProps.production)}";
    _line2Value.text = "${sector.getProp(SimProps.credit)}";
    _line3Value.text = "${sector.getProp(SimProps.science)}";
  }

  void _calcScrollBounds() {
    double contentHeight = _infoBackground.size.y + 8;

    scrollBoundsY = _clip.size.y - contentHeight;
  }
}
