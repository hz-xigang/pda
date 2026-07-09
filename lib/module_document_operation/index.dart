import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/module_document_operation/components/document_operation_confirm_bar.dart';
import 'package:hz_xg_pda/module_document_operation/components/document_operation_document_section.dart';
import 'package:hz_xg_pda/module_document_operation/components/document_operation_order_type_section.dart';
import 'package:hz_xg_pda/module_document_operation/components/document_operation_product_list.dart';
import 'package:hz_xg_pda/module_document_operation/components/document_operation_total_count.dart';
import 'package:hz_xg_pda/module_document_operation/state/document_operation_state.dart';

class DocumentOperationPage extends StatefulWidget {
  const DocumentOperationPage({super.key});

  @override
  State<DocumentOperationPage> createState() => _DocumentOperationPageState();
}

class _DocumentOperationPageState extends State<DocumentOperationPage> {
  late final DocumentOperationState _state;

  @override
  void initState() {
    super.initState();
    _state = DocumentOperationState();
  }

  @override
  void dispose() {
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: SafeArea(
        child: DocumentOperationScope(
          notifier: _state,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: const _DocumentOperationBody(),
          ),
        ),
      ),
    );
  }
}

class _DocumentOperationBody extends StatelessWidget {
  const _DocumentOperationBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBackBar(onTap: () => Navigator.pop(context)),
        const SizedBox(height: 12),
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                DocumentOperationOrderTypeSection(),
                SizedBox(height: 16),
                DocumentOperationDocumentSection(),
                SizedBox(height: 16),
                DocumentOperationTotalCount(),
                SizedBox(height: 16),
                DocumentOperationProductList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const DocumentOperationConfirmBar(),
      ],
    );
  }
}
