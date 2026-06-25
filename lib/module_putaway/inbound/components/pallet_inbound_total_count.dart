import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/total_count_card.dart';

class PalletInboundTotalCount extends StatelessWidget {
  const PalletInboundTotalCount({
    super.key,
    required this.count,
  });

  final int count;

  @override
  Widget build(BuildContext context) {
    return TotalCountCard(
      count: count,
      backgroundColor: const Color(0xFFE5F7FF),
      accentColor: const Color(0xFF18A8F1),
    );
  }
}
