import 'package:flutter/material.dart';
import 'package:hz_xg_pda/module_document_operation/document_operation_theme.dart';
import 'package:hz_xg_pda/module_document_operation/state/document_operation_state.dart';

class DocumentOperationTotalCount extends StatelessWidget {
  const DocumentOperationTotalCount({super.key});

  @override
  Widget build(BuildContext context) {
    final state = DocumentOperationScope.watch(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x12000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: documentOperationBoxBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              size: 20,
              color: documentOperationBoxIconColor,
            ),
          ),
          const SizedBox(width: 10),
          const Text(
            '总件数',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const Spacer(),
          Text(
            '${state.totalCount}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: documentOperationAccentColor,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
