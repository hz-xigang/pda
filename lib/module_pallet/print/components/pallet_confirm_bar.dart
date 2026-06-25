import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/primary_action_button.dart';

class PalletConfirmBar extends StatelessWidget {
  const PalletConfirmBar({
    super.key,
    required this.onConfirm,
  });

  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return PrimaryActionButton(
      onPressed: onConfirm,
      icon: Icons.check_rounded,
      label: '确认打托',
      backgroundColor: const Color(0xFF8B3DFF),
      height: 54,
    );
  }
}
