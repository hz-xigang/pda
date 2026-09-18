import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/module_document_operation/prep/components/prep_confirm_bar.dart';
import 'package:hz_xg_pda/module_document_operation/prep/components/prep_document_section.dart';
import 'package:hz_xg_pda/module_document_operation/prep/components/prep_location_section.dart';
import 'package:hz_xg_pda/module_document_operation/prep/components/prep_product_list.dart';
import 'package:hz_xg_pda/module_document_operation/prep/components/prep_total_count.dart';
import 'package:hz_xg_pda/module_document_operation/prep/state/prep_state.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';

class PrepOperationPage extends StatefulWidget {
  const PrepOperationPage({super.key});

  @override
  State<PrepOperationPage> createState() => _PrepOperationPageState();
}

class _PrepOperationPageState extends State<PrepOperationPage> {
  late final PrepState _state;
  StreamSubscription<String>? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _state = PrepState();
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
        child: PrepScope(
          notifier: _state,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: const _PrepOperationBody(),
          ),
        ),
      ),
    );
  }
}

class _PrepOperationBody extends StatelessWidget {
  const _PrepOperationBody();

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
                PrepDocumentSection(),
                SizedBox(height: 16),
                PrepLocationSection(),
                SizedBox(height: 16),
                PrepTotalCount(),
                SizedBox(height: 16),
                PrepProductList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const PrepConfirmBar(),
      ],
    );
  }
}
