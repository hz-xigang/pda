import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/workflow_step_indicator.dart';
import 'package:hz_xg_pda/module_putaway/move/state/move_state.dart';

class MoveStepIndicator extends StatelessWidget {
  const MoveStepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final state = MoveScope.watch(context);

    return WorkflowStepIndicator(
      currentStep: state.currentStep,
      activeColor: const Color(0xFF00B894),
      firstLabel: '扫描产品',
      secondLabel: '确认移库',
    );
  }
}
