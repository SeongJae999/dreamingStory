import 'package:flutter/material.dart';

class TextUtil extends StatelessWidget {
  final String text;
  final bool? weight;
  final double? size;
  final Color? color;
  final String? fontFamily;
  final Color? outlineColor;
  final double? outlineWidth;

  const TextUtil({
    required this.text,
    this.weight,
    this.size,
    this.color,
    this.fontFamily,
    this.outlineColor,
    this.outlineWidth,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: weight == true ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
        fontFamily: fontFamily,
        foreground: outlineColor != null && outlineWidth != null
            ? (Paint()
              ..style = PaintingStyle.stroke
              ..strokeWidth = outlineWidth!
              ..color = outlineColor!)
            : null,
        color: outlineColor == null ? color : null, // 테두리가 있을 때는 color 제거
      ),
    );
  }
}
