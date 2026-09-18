import 'package:flutter/material.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/components/section_title.dart';
import 'package:hz_xg_pda/module_document_operation/document_operation_theme.dart';
import 'package:hz_xg_pda/module_document_operation/ship/state/ship_state.dart';

import 'package:hz_xg_pda/entity/DocumentOperationDocumentOption.dart';

class ShipDocumentSection extends StatelessWidget {
  const ShipDocumentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NotifierScope.watch<ShipState>(context);
    final selected = state.selectedDocument;
    const label = '选择发货单号';


    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: '单据选择',
          color: documentOperationAccentColor,
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF4B5563),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<DocumentOperationDocumentOption>(
                value: selected,
                hint: const Text('暂无可用单据'),
                disabledHint: selected == null
                    ? const Text('暂无可用单据')
                    : Text(selected.no),
                items: state.documentOptions
                    .map(
                      (item) => DropdownMenuItem<DocumentOperationDocumentOption>(
                        value: item,
                        child: Text(item.no),
                      ),
                    )
                    .toList(growable: false),
                onChanged: state.canSwitchSelectors
                    ? state.updateDocument
                    : null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFD7DFEC),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFD7DFEC),
                    ),
                  ),
                ),
              ),
              if (selected != null) ...[
                const SizedBox(height: 12),
                const Text(
                  '单号明细',
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF4B5563),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

}
