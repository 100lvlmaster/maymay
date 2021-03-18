import 'dart:ui';

import 'package:flutter/material.dart';

const kDemoText = Center(
  child: Text(
    'Child will be here.',
    style: TextStyle(
      fontSize: 25,
      color: Colors.white,
      letterSpacing: 2,
    ),
    textAlign: TextAlign.center,
  ),
);
const double kBlur = 1.0;
const EdgeInsetsGeometry kDefaultPadding = EdgeInsets.all(16);
const Color kDefaultColor = Colors.transparent;
const BorderRadius kBorderRadius = BorderRadius.all(Radius.circular(20));
const double kColorOpacity = 0.0;

class BlurryContainer extends StatelessWidget {
  final Widget child;
  final double blur;
  final EdgeInsetsGeometry padding;
  final Color bgColor;

  final BorderRadius borderRadius;

  //final double colorOpacity;

  BlurryContainer({
    @required this.child,
    this.blur = 10,
    this.padding = kDefaultPadding,
    this.bgColor = kDefaultColor,
    this.borderRadius = kBorderRadius,
    //this.colorOpacity = kColorOpacity,
  });

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
      child: Container(
        color:
            bgColor == Colors.transparent ? bgColor : bgColor.withOpacity(0.5),
        child: child,
      ),
    );
  }
}
