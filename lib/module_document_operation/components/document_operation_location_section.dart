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
    final bool isScanning = state.isScanningLocation;
    final LocArchive? selected = state.selectedLocation;
    const Color accentColor = documentOperationAccentColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SectionTitle(
              title: '目标仓位',
              color: accentColor,
            ),
            const Spacer(),
            if (isScanning)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 10,
                      height: 10,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: accentColor,
                      ),
                    ),
                    SizedBox(width: 6),
                    Text(
                      '等待扫描...',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: accentColor,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          elevation: isScanning ? 4 : 1,
          shadowColor: isScanning
              ? accentColor.withValues(alpha: 0.3)
              : const Color(0x12000000),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () => state.toggleScanLocationMode(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: isScanning ? accentColor : const Color(0xFFD7DFEC),
                  width: isScanning ? 2 : 1,
                ),
                color: isScanning
                    ? accentColor.withValues(alpha: 0.04)
                    : Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: isScanning
                          ? accentColor
                          : (selected != null
                              ? accentColor.withValues(alpha: 0.12)
                              : const Color(0xFFF3F4F6)),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.qr_code_scanner,
                      color: isScanning
                          ? Colors.white
                          : (selected != null
                              ? accentColor
                              : const Color(0xFF9CA3AF)),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isScanning
                              ? '正在等待扫描仓位条码'
                              : (selected != null ? '当前目标仓位' : '尚未选择目标仓位'),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isScanning
                                ? accentColor
                                : const Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          isScanning
                              ? '请对准仓位标签扫码'
                              : (selected?.locCode ?? '点击此处开始扫描仓位'),
                          style: TextStyle(
                            fontSize:
                                selected != null && !isScanning ? 17 : 15,
                            fontWeight: FontWeight.bold,
                            color: isScanning
                                ? accentColor
                                : (selected != null
                                    ? const Color(0xFF111827)
                                    : const Color(0xFF9CA3AF)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isScanning
                          ? Colors.red.withValues(alpha: 0.1)
                          : accentColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      isScanning ? '取消' : (selected != null ? '重新扫描' : '扫描'),
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isScanning ? Colors.red : accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
