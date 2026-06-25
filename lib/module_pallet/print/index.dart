import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';

import 'components/pallet_confirm_bar.dart';
import 'components/pallet_product_list.dart';
import 'components/pallet_step_indicator.dart';
import 'components/pallet_total_count.dart';
import 'state/pallet_state.dart';

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
    _scanSubscription = PdaUtil().onScanResult.listen((result){
      _palletState.onScanProduct(result,context);
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
    final state = PalletScope.watch(context);

    return Column(
      children: [
        AppBackBar(onTap: () => Navigator.pop(context)),
        const SizedBox(height: 12),
        PalletStepIndicator(currentStep: state.currentStep),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                PalletTotalCount(count: state.totalCount),
                const SizedBox(height: 16),
                PalletProductList(products: state.products),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        PalletConfirmBar(onConfirm: () => state.confirmPallet(context)),
      ],
    );
  }
}
