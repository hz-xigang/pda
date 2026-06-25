import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/module_pallet/print/components/pallet_confirm_bar.dart';
import 'package:hz_xg_pda/module_pallet/print/components/pallet_product_list.dart';
import 'package:hz_xg_pda/module_pallet/print/components/pallet_step_indicator.dart';
import 'package:hz_xg_pda/module_pallet/print/components/pallet_total_count.dart';
import 'package:hz_xg_pda/module_pallet/print/state/pallet_state.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';

class PalletOperationPage extends StatefulWidget {
  const PalletOperationPage({super.key});

  @override
  State<PalletOperationPage> createState() => _PalletOperationPageState();
}

class _PalletOperationPageState extends State<PalletOperationPage> {
  StreamSubscription<String>? _scanSubscription;
  late final PalletState _palletState;

  @override
  void initState() {
    super.initState();
    _palletState = PalletState();
    _scanSubscription = PdaUtil().onScanResult.listen((result) {
      _palletState.onScanProduct(result, context);
    });
  }

  @override
  void dispose() {
    _scanSubscription?.cancel();
    _palletState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F6FB),
      body: SafeArea(
        child: PalletScope(
          notifier: _palletState,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: const _PalletBody(),
          ),
        ),
      ),
    );
  }
}

class _PalletBody extends StatelessWidget {
  const _PalletBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBackBar(onTap: () => Navigator.pop(context)),
        const SizedBox(height: 12),
        const PalletStepIndicator(),
        const SizedBox(height: 12),
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PalletTotalCount(),
                SizedBox(height: 16),
                PalletProductList(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const PalletConfirmBar(),
      ],
    );
  }
}
