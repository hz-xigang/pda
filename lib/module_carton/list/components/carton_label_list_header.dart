import 'package:flutter/material.dart';

class CartonLabelListHeader extends StatelessWidget {
  const CartonLabelListHeader({
    super.key,
    required this.prodNo,
  });

  final String prodNo;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: const BoxDecoration(
            color: Color(0xFF2E61F3),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            '生产单号:  $prodNo',
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              color: Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }
}
