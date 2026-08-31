import 'package:flutter/material.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/components/workflow/primary_action_button.dart';
import 'package:hz_xg_pda/module_pallet/unbundle/state/unbundle_pallet_state.dart';

class UnbundlePalletConfirmBar extends StatelessWidget {
  const UnbundlePalletConfirmBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NotifierScope.read<UnbundlePalletState>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (state.palletNo != null && state.tags.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '已选 ${state.selectedCount} / ${state.totalCount}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF9AA3B8),
                  ),
                ),
              ],
            ),
          ),
        PrimaryActionButton(
          onPressed: () => state.confirmUnbundle(context),
          icon: Icons.unarchive_outlined,
          label: '确认拆托',
          backgroundColor: const Color(0xFFE86B3C),
          height: 54,
        ),
      ],
    );
  }
}
