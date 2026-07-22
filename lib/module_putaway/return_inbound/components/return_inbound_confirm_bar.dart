import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/primary_action_button.dart';
import 'package:hz_xg_pda/module_putaway/return_inbound/state/return_inbound_state.dart';

class ReturnInboundConfirmBar extends StatelessWidget {
  const ReturnInboundConfirmBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ReturnInboundScope.read(context);

    return PrimaryActionButton(
      onPressed: () => state.confirmReturnInbound(context),
      icon: Icons.assignment_return_outlined,
      label: '确认退货入库',
      backgroundColor: const Color(0xFFFF4D5E),
      height: 58,
    );
  }
}
