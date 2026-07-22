import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/workflow_step_indicator.dart';
import 'package:hz_xg_pda/module_putaway/return_inbound/state/return_inbound_state.dart';

class ReturnInboundStepIndicator extends StatelessWidget {
  const ReturnInboundStepIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ReturnInboundScope.watch(context);

    return WorkflowStepIndicator(
      currentStep: state.currentStep,
      activeColor: const Color(0xFFFF4D5E),
      firstLabel: '扫描产品',
      secondLabel: '确认退货入库',
    );
  }
}
