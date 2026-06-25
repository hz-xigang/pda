import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/workflow_step_indicator.dart';

class PalletStepIndicator extends StatelessWidget {
  const PalletStepIndicator({
    super.key,
    required this.currentStep,
  });

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return WorkflowStepIndicator(
      currentStep: currentStep,
      activeColor: const Color(0xFF8B3DFF),
      firstLabel: '扫描产品',
      secondLabel: '确认打托',
    );
  }
}
