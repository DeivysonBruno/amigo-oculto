import 'package:flutter/material.dart';

class AppColors {
  static final primary = Colors.lightBlue;
  static final scaleOrange = _hexToColor("#FF9800");
  static final lightRed = _hexToColor("#A80000");
  static final darkRed = _hexToColor("#A20000");
  static final lightOrange = _hexToColor("FFC947");
  static final darkOrange = _hexToColor("#DB7503");
  static final background = _hexToColor("#C2CEDB");
  static final textColor = _hexToColor("#414A54");
  static final blue = _hexToColor("#3B5999");

  static Color _hexToColor(String hexColor) {
    String newColor = '0xff' + hexColor.replaceAll("#", "");
    int hexColorInFlutter = int.parse(newColor);
    return Color(hexColorInFlutter);
  }

  static Color hexToColor(String hexColor) {
    String newColor = '0xff' + hexColor.replaceAll("#", "");
    int hexColorInFlutter = int.parse(newColor);
    return Color(hexColorInFlutter);
  }

  static String hexOfRGBA(int r, int g, int b, {double opacity = 1}) {
    r = (r < 0) ? -r : r;
    g = (g < 0) ? -g : g;
    b = (b < 0) ? -b : b;
    opacity = (opacity < 0) ? -opacity : opacity;
    opacity = (opacity > 1) ? 255 : opacity * 255;
    r = (r > 255) ? 255 : r;
    g = (g > 255) ? 255 : g;
    b = (b > 255) ? 255 : b;
    return ('${r.toRadixString(16).padLeft(2, "0")}${g.toRadixString(16).padLeft(2, "0")}${b.toRadixString(16).padLeft(2, "0")}')
        .toString();
  }
}
