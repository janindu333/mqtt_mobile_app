import 'dart:ui';
import 'package:flutter/material.dart';

class ColorConstant {
  static Color bluegray900 = fromHex('#272a2f');

  static Color gray600 = fromHex('#7e7e7e');

  static Color gray80019 = fromHex('#19404040');

  static Color black900 = fromHex('#000000');

  static Color bluegray400 = fromHex('#888888');

  static Color bluegray100 = fromHex('#cdcdcd');

  static Color redA400 = fromHex('#ff2156');

  static Color bluegray90019 = fromHex('#192e2e2e');

  static Color whiteA700 = fromHex('#ffffff');

  static Color gray100 = fromHex('#f5f5f5');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
