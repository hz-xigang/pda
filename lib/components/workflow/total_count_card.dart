import 'package:flutter/material.dart';

class TotalCountCard extends StatelessWidget {
  const TotalCountCard({
    super.key,
    required this.count,
    required this.backgroundColor,
    required this.accentColor,
    this.label = '总件数',
  });

  final int count;
  final Color backgroundColor;
  final Color accentColor;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: accentColor,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.inventory_outlined,
              size: 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              color: Color(0xFF4B5563),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: accentColor,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
