import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/primary_action_button.dart';
import 'package:hz_xg_pda/module_putaway/move/state/move_state.dart';

class MoveConfirmBar extends StatelessWidget {
  const MoveConfirmBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MoveScope.read(context);

    return PrimaryActionButton(
      onPressed: () => state.confirmMove(context),
      icon: Icons.swap_horiz_rounded,
      label: '确认移库',
      backgroundColor: const Color(0xFF00B894),
      height: 58,
    );
  }
}
