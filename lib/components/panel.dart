import 'dart:ui';

import 'package:flame/components.dart';
import "../theme.dart" show panelBackground, panelBottomBorder, yellow;

class Panel extends RectangleComponent {
  static final yellowPainter = Paint()
    ..color = yellow
    ..strokeWidth = 1;

  Offset topLeft = Offset.zero;
  Offset topRight = Offset.zero;
  Offset bottomLeft = Offset.zero;
  Offset bottomRight = Offset.zero;

  Panel({
    super.position,
    super.size,
    super.scale,
    super.angle,
    super.anchor,
    super.children,
    super.priority,
    super.key,
  }) : super(paint: panelBackground) {
    refreshBorder();
    size.addListener(refreshBorder);
  }

  void refreshBorder() {
    topLeft = vertices[0].toOffset();
    topRight = vertices[3].toOffset();
    bottomLeft = vertices[1].toOffset();
    bottomRight = vertices[2].toOffset();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    canvas.drawLine(topLeft, topRight, yellowPainter);
    canvas.drawLine(bottomLeft, bottomRight, panelBottomBorder);
  }
}
