import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/total_count_card.dart';
import 'package:hz_xg_pda/module_putaway/return_inbound/state/return_inbound_state.dart';

class ReturnInboundTotalCount extends StatelessWidget {
  const ReturnInboundTotalCount({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ReturnInboundScope.watch(context);

    return TotalCountCard(
      count: state.totalCount,
      backgroundColor: const Color(0xFFFFEDF0),
      accentColor: const Color(0xFFFF4D5E),
    );
  }
}
