import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/workflow_step_indicator.dart';
import 'package:hz_xg_pda/module_pallet/print/state/pallet_state.dart';

class PalletStepIndicator extends StatelessWidget {
  const PalletStepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final state = PalletScope.watch(context);

    return WorkflowStepIndicator(
      currentStep: state.currentStep,
      activeColor: const Color(0xFF8B3DFF),
      firstLabel: '扫描产品',
      secondLabel: '确认打托',
    );
  }
}
