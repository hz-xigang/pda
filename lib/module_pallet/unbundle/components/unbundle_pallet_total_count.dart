import 'package:flutter/material.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/components/workflow/total_count_card.dart';
import 'package:hz_xg_pda/module_pallet/unbundle/state/unbundle_pallet_state.dart';

class UnbundlePalletTotalCount extends StatelessWidget {
  const UnbundlePalletTotalCount({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NotifierScope.watch<UnbundlePalletState>(context);

    return TotalCountCard(
      count: state.totalCount,
      backgroundColor: const Color(0xFFFFF0E9),
      accentColor: const Color(0xFFE86B3C),
      label: '托盘标签数',
    );
  }
}
