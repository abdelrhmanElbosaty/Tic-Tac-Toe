import 'package:flutter/material.dart';
import 'package:tic_tak_toe/core/dimensions.dart';

class TextStyles {
  static const double _baseFontSize = Dimensions.header;

  static TextStyle bold({
    Color color = Colors.black,
    double fontSize = _baseFontSize,
    double? height,
    TextOverflow? textOverFlow,
  }) =>
      TextStyle(
        height: height,
        color: color,
        fontSize: fontSize,
        overflow: textOverFlow,
        fontWeight: FontWeight.w700,
      );

  static TextStyle semiBold(
          {Color color = Colors.black,
          double fontSize = _baseFontSize,
          double? height}) =>
      TextStyle(
        height: height,
        color: color,
        fontSize: fontSize,
        fontWeight: FontWeight.w600,
      );

  static TextStyle medium(
          {Color color = Colors.black,
          double fontSize = _baseFontSize,
          TextOverflow? textOverFlow,
          double? height}) =>
      TextStyle(
        height: height,
        color: color,
        fontSize: fontSize,
        overflow: textOverFlow ?? TextOverflow.visible,
        fontWeight: FontWeight.w500,
      );

  static TextStyle regular(
      {Color color = Colors.black,
      double fontSize = _baseFontSize,
      TextOverflow? textOverFlow,
      double? height}) {
    return TextStyle(
      height: height,
      color: color,
      fontSize: fontSize,
      overflow: textOverFlow ?? TextOverflow.visible,
      fontWeight: FontWeight.w400,
    );
  }
}
