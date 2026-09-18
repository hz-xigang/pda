import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/module_document_operation/transfer/components/transfer_confirm_bar.dart';
import 'package:hz_xg_pda/module_document_operation/transfer/components/transfer_document_section.dart';
import 'package:hz_xg_pda/module_document_operation/transfer/components/transfer_product_list.dart';
import 'package:hz_xg_pda/module_document_operation/transfer/components/transfer_total_count.dart';
import 'package:hz_xg_pda/module_document_operation/transfer/state/transfer_state.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';

class TransferOperationPage extends StatefulWidget {
  const TransferOperationPage({super.key});

  @override
  State<TransferOperationPage> createState() => _TransferOperationPageState();
}

class _TransferOperationPageState extends State<TransferOperationPage> {
  late final TransferState _state;
  StreamSubscription<String>? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _state = TransferState();
    _scanSubscription = PdaUtil().onScanResult.listen((result) {
      if (!mounted) return;
      _state.onScan(result, context);
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _state.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: SafeArea(
        child: TransferScope(
          notifier: _state,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: const _TransferOperationBody(),
          ),
        ),
      ),
    );
  }
}

class _TransferOperationBody extends StatelessWidget {
  const _TransferOperationBody();

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
                TransferDocumentSection(),
                SizedBox(height: 16),
                TransferTotalCount(),
                SizedBox(height: 16),
                TransferProductList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const TransferConfirmBar(),
      ],
    );
  }
}
