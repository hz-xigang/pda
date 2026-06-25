import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/primary_action_button.dart';

class PalletInboundConfirmBar extends StatelessWidget {
  const PalletInboundConfirmBar({
    super.key,
    required this.onConfirm,
  });

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      onPressed: onConfirm,
      icon: Icons.assignment_turned_in_outlined,
      label: '确认入库',
      backgroundColor: const Color(0xFF18A8F1),
      height: 58,
    );
  }
}
