import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/module_document_operation/ship/components/ship_confirm_bar.dart';
import 'package:hz_xg_pda/module_document_operation/ship/components/ship_document_section.dart';
import 'package:hz_xg_pda/module_document_operation/ship/components/ship_product_list.dart';
import 'package:hz_xg_pda/module_document_operation/ship/components/ship_total_count.dart';
import 'package:hz_xg_pda/module_document_operation/ship/state/ship_state.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';

class ShipOperationPage extends StatefulWidget {
  const ShipOperationPage({super.key});

  @override
  State<ShipOperationPage> createState() => _ShipOperationPageState();
}

class _ShipOperationPageState extends State<ShipOperationPage> {
  late final ShipState _state;
  StreamSubscription<String>? _scanSubscription;

  @override
  void initState() {
    super.initState();
    _state = ShipState();
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
        child: ShipScope(
          notifier: _state,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: const _ShipOperationBody(),
          ),
        ),
      ),
    );
  }
}

class _ShipOperationBody extends StatelessWidget {
  const _ShipOperationBody();

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
                ShipDocumentSection(),
                SizedBox(height: 16),
                ShipTotalCount(),
                SizedBox(height: 16),
                ShipProductList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const ShipConfirmBar(),
      ],
    );
  }
}
