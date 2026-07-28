import 'package:flutter/material.dart';

class BoxButton extends StatelessWidget {
  const BoxButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width,
    this.height,
    this.backgroundColor,
    this.strokeColor,
  });

  final String title;
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? strokeColor;

  @override
  Widget build(BuildContext context) {
    // 设置默认宽度和高度
    final double bWidth = width ?? MediaQuery.of(context).size.width - 100;
    final double bHeight = height ?? 60;
    final Color solidColor = backgroundColor ?? Color(0xFFFFE0D1);
    final Color sideColor = strokeColor ?? Color(0xFFFDC29C);

    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        fixedSize: Size(bWidth, bHeight),
        //border color
        side: BorderSide(color: sideColor),
        //border shape
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        backgroundColor: solidColor,
        textStyle: TextStyle(fontSize: 20),
      ),
      child: Text(title, style: TextStyle(color: Colors.black)),
    );
  }
}
