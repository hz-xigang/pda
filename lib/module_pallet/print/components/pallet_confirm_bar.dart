import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/primary_action_button.dart';
import 'package:hz_xg_pda/module_pallet/print/state/pallet_state.dart';

class PalletConfirmBar extends StatelessWidget {
  const PalletConfirmBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = PalletScope.read(context);

    return PrimaryActionButton(
      onPressed: () => state.confirmPallet(context),
      icon: Icons.check_rounded,
      label: '确认打托',
      backgroundColor: const Color(0xFF8B3DFF),
      height: 54,
    );
  }
}
