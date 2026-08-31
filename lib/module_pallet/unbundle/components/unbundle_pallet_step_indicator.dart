import 'package:flutter/material.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/components/workflow/workflow_step_indicator.dart';
import 'package:hz_xg_pda/module_pallet/unbundle/state/unbundle_pallet_state.dart';

class UnbundlePalletStepIndicator extends StatelessWidget {
  const UnbundlePalletStepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NotifierScope.watch<UnbundlePalletState>(context);

    return WorkflowStepIndicator(
      currentStep: state.currentStep,
      activeColor: const Color(0xFFE86B3C),
      firstLabel: '扫描托盘',
      secondLabel: '确认拆托',
    );
  }
}
