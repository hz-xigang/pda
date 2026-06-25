import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/total_count_card.dart';

class PalletTotalCount extends StatelessWidget {
  const PalletTotalCount({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return TotalCountCard(
      count: count,
      backgroundColor: const Color(0xFFF1E8FF),
      accentColor: const Color(0xFF8B3DFF),
    );
  }
}
