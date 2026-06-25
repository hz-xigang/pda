import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/total_count_card.dart';
import 'package:hz_xg_pda/module_pallet/print/state/pallet_state.dart';

class PalletTotalCount extends StatelessWidget {
  const PalletTotalCount({super.key});

  @override
  Widget build(BuildContext context) {
    final state = PalletScope.watch(context);

    return TotalCountCard(
      count: state.totalCount,
      backgroundColor: const Color(0xFFF1E8FF),
      accentColor: const Color(0xFF8B3DFF),
    );
  }
}
