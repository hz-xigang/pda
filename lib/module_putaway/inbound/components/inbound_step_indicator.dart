import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/workflow_step_indicator.dart';
import 'package:hz_xg_pda/module_putaway/inbound/state/inbound_state.dart';

class InboundStepIndicator extends StatelessWidget {
  const InboundStepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final state = InboundScope.watch(context);

    return WorkflowStepIndicator(
      currentStep: state.currentStep,
      activeColor: const Color(0xFF18A8F1),
      firstLabel: '扫描产品',
      secondLabel: '确认入库',
    );
  }
}
