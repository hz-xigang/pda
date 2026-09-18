import 'package:flutter/material.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/components/workflow/primary_action_button.dart';
import 'package:hz_xg_pda/module_document_operation/document_operation_theme.dart';
import 'package:hz_xg_pda/module_document_operation/prep/state/prep_state.dart';

class PrepConfirmBar extends StatelessWidget {
  const PrepConfirmBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NotifierScope.read<PrepState>(context);

    return PrimaryActionButton(
      onPressed: () => state.confirmOperation(context),
      icon: Icons.check_box_rounded,
      label: '确认操作',
      backgroundColor: documentOperationAccentColor,
      height: 58,
    );
  }
}
