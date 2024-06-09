import 'package:flutter/material.dart';

extension TextSize on String {
  double get getWidth {
    final textSpan = TextSpan(
      text: this,
      style: const TextStyle(fontSize: 16),
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    tp.layout();
    return tp.width;
  }
}
