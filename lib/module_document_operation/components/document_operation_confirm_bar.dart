import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/workflow/primary_action_button.dart';
import 'package:hz_xg_pda/module_document_operation/document_operation_theme.dart';
import 'package:hz_xg_pda/module_document_operation/state/document_operation_state.dart';

class DocumentOperationConfirmBar extends StatelessWidget {
  const DocumentOperationConfirmBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = DocumentOperationScope.read(context);

    return PrimaryActionButton(
      onPressed: () => state.confirmOperation(context),
      icon: Icons.check_box_rounded,
      label: '确认操作',
      backgroundColor: documentOperationAccentColor,
      height: 58,
    );
  }
}
