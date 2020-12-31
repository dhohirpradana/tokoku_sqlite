import 'package:flutter/material.dart';

class MyTextStyle extends TextStyle {
  final Color color;
  final FontWeight fontWeight;
  final double size;
  final String fontFamily;

  const MyTextStyle({
    @required this.fontWeight,
    this.size = 14,
    this.color,
    this.fontFamily = 'Montserrat',
  })  : assert(fontWeight != null),
        super(
          fontWeight: fontWeight,
          fontSize: size,
          fontFamily: fontFamily,
        );
}
