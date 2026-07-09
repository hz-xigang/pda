import 'package:flutter/material.dart';
import 'package:hz_xg_pda/module_document_operation/document_operation_theme.dart';
import 'package:hz_xg_pda/module_document_operation/state/document_operation_state.dart';

class DocumentOperationScanPrompt extends StatelessWidget {
  const DocumentOperationScanPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final state = DocumentOperationScope.read(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          decoration: BoxDecoration(
            color: const Color(0xFFF9FBFE),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: const Color(0xFFD8E1EC),
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.photo_camera_rounded,
                  size: 28,
                  color: Color(0xFF9AA3B8),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '扫描产品条码',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: documentOperationAccentColor,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '点击或使用PDA扫描键',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF9AA3B8),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
