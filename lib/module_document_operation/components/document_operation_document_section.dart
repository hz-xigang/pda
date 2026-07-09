import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/section_title.dart';
import 'package:hz_xg_pda/module_document_operation/document_operation_theme.dart';
import 'package:hz_xg_pda/module_document_operation/state/document_operation_state.dart';

class DocumentOperationDocumentSection extends StatelessWidget {
  const DocumentOperationDocumentSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = DocumentOperationScope.watch(context);
    final selected = state.selectedDocument;
    final label = _buildLabel(state.selectedOrderType.key);

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
                items: state.documentOptions
                    .map(
                      (item) => DropdownMenuItem<DocumentOperationDocumentOption>(
                        value: item,
                        child: Text(item.label),
                      ),
                    )
                    .toList(growable: false),
                onChanged: state.updateDocument,
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
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        selected.summaryName,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF4B5563),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: documentOperationLightColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${selected.summarySpec} | 数量 ${selected.summaryQty} 件',
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF111827),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  String _buildLabel(String orderTypeKey) {
    switch (orderTypeKey) {
      case 'stock_prepare':
        return '选择备货单号';
      case 'delivery_out':
        return '选择发货单号';
      case 'transfer_out':
      default:
        return '选择调拨单号';
    }
  }
}
