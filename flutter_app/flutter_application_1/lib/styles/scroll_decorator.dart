import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ScrollDecorator extends SingleChildRenderObjectWidget {
  const ScrollDecorator({
    Key? key,
    required Widget child,
  }) : super(key: key, child: child);

  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderScrollDecorator();
  }
}

class RenderScrollDecorator extends RenderProxyBox {
  @override
  void paint(PaintingContext context, Offset offset) {
    // Draw a gradient overlay
    final Paint paint = Paint()
      ..shader = LinearGradient(
        colors: [const Color.fromARGB(255, 255, 213, 251), const Color.fromARGB(255, 255, 184, 249).withOpacity(0.5)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(offset.dx, offset.dy, size.width, size.height));

    context.canvas.drawRect(offset & size, paint);

    // Call the paint method of the child
    super.paint(context, offset);
  }
}