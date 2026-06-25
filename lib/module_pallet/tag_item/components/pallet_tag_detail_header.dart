import 'package:flutter/material.dart';

class PalletTagDetailHeader extends StatelessWidget {
  const PalletTagDetailHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            SizedBox(
              width: 9,
              height: 9,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: Color(0xFF2E61F3),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            SizedBox(width: 8),
            Text(
              '条码明细',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        SizedBox(height: 6),
        Text(
          '点击条码选择要删除的项',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF6B7280),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
