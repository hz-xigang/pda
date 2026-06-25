import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/workflow_step_indicator.dart';

class PalletInboundStepIndicator extends StatelessWidget {
  const PalletInboundStepIndicator({
    super.key,
    required this.currentStep,
  });

  final int currentStep;

  @override
  Widget build(BuildContext context) {
    return WorkflowStepIndicator(
      currentStep: currentStep,
      activeColor: const Color(0xFF18A8F1),
      firstLabel: '扫描产品',
      secondLabel: '确认入库',
    );
  }
}
