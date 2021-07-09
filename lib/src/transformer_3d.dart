import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:transformer_page_view/transformer_page_view.dart';

class Transformer3D extends PageTransformer {
  final double scale;
  final double fade;
  final double viewportFraction;
  BuildContext context;

  Transformer3D(this.context,
      {this.fade = 0.5, this.scale = 0.7, this.viewportFraction});

  @override
  Widget transform(Widget item, TransformInfo info) {
    double position = info.position;
    print('$position');
    Widget child = item;
    double scaleF = 0;
    if (scale != null) {
      double scaleFactor = (1 - position.abs()) * (1 - scale);
      scaleF = scale + scaleFactor;

      child = new Transform.scale(
        scale: scaleF,
        child: item,
      );
    }
    if (fade != null) {
      double fadeFactor = (1 - position.abs()) * (1 - fade);
      double opacity = fade + fadeFactor;
      child = new Opacity(
        opacity: opacity,
        child: child,
      );
    }

    if (position.abs() != 0) {
      child = ClipRect(
        clipper: PageCustomClipper((-position * position.abs()) * info.width,
            info.width * viewportFraction),
        child: child,
      );
    }

    child = Transform.translate(
      offset: Offset((position * position.abs()) * info.width, 0),
      child: child,
    );

    return child;
  }
}

class PageCustomClipper extends CustomClipper<Rect> {
  double left;
  double width;

  PageCustomClipper(this.left, this.width);

  @override
  bool shouldReclip(covariant CustomClipper<Rect> oldClipper) {
    return true;
  }

  @override
  Rect getClip(Size size) {
    return Rect.fromLTWH(left, 0, width, size.height);
  }
}
