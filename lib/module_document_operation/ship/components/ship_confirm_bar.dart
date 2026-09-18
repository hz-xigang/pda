import 'package:flutter/material.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/components/workflow/primary_action_button.dart';
import 'package:hz_xg_pda/module_document_operation/document_operation_theme.dart';
import 'package:hz_xg_pda/module_document_operation/ship/state/ship_state.dart';

class ShipConfirmBar extends StatelessWidget {
  const ShipConfirmBar({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NotifierScope.read<ShipState>(context);

    return PrimaryActionButton(
      onPressed: () => state.confirmOperation(context),
      icon: Icons.check_box_rounded,
      label: '确认操作',
      backgroundColor: documentOperationAccentColor,
      height: 58,
    );
  }
}
