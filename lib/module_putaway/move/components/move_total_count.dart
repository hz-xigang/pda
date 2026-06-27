import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/total_count_card.dart';
import 'package:hz_xg_pda/module_putaway/move/state/move_state.dart';

class MoveTotalCount extends StatelessWidget {
  const MoveTotalCount({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MoveScope.watch(context);

    return TotalCountCard(
      count: state.totalCount,
      backgroundColor: const Color(0xFFE3FBF5),
      accentColor: const Color(0xFF00B894),
    );
  }
}
