import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/total_count_card.dart';
import 'package:hz_xg_pda/module_putaway/inbound/state/inbound_state.dart';

class InboundTotalCount extends StatelessWidget {
  const InboundTotalCount({super.key});

  @override
  Widget build(BuildContext context) {
    final state = InboundScope.watch(context);

    return TotalCountCard(
      count: state.totalCount,
      backgroundColor: const Color(0xFFE5F7FF),
      accentColor: const Color(0xFF18A8F1),
    );
  }
}
