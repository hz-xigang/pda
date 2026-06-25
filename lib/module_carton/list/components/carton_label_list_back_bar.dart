import 'package:flutter/material.dart';

class CartonLabelListBackBar extends StatelessWidget {
  const CartonLabelListBackBar({
    super.key,
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 14,
                color: Color(0xFF2E61F3),
              ),
              SizedBox(width: 2),
              Text(
                '返回打印',
                style: TextStyle(
                  color: Color(0xFF2E61F3),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
