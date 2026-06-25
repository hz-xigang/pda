import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/primary_action_button.dart';
import 'package:hz_xg_pda/module_putaway/inbound/state/inbound_state.dart';

class InboundConfirmBar extends StatelessWidget {
  const InboundConfirmBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = InboundScope.read(context);

    return PrimaryActionButton(
      onPressed: () => state.confirmInbound(context),
      icon: Icons.assignment_turned_in_outlined,
      label: '确认入库',
      backgroundColor: const Color(0xFF18A8F1),
      height: 58,
    );
  }
}
