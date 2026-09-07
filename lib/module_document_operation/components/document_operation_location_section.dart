import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/section_title.dart';
import 'package:hz_xg_pda/entity/loc_archive.dart';
import 'package:hz_xg_pda/module_document_operation/document_operation_theme.dart';
import 'package:hz_xg_pda/module_document_operation/state/document_operation_state.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';

class DocumentOperationLocationSection extends StatelessWidget {
  const DocumentOperationLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NotifierScope.watch<DocumentOperationState>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionTitle(
          title: '目标仓位',
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
              const Text(
                '仓位',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF4B5563),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<LocArchive>(
                value: state.selectedLocation,
                hint: const Text('请选择仓位'),
                items: state.locationOptions
                    .map(
                      (item) => DropdownMenuItem<LocArchive>(
                        value: item,
                        child: Text(item.locCode ?? '--'),
                      ),
                    )
                    .toList(growable: false),
                onChanged: state.canSwitchSelectors
                    ? (value) => state.updateLocation(value)
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
            ],
          ),
        ),
      ],
    );
  }
}
