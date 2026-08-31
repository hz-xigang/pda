import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/module_pallet/unbundle/components/unbundle_pallet_confirm_bar.dart';
import 'package:hz_xg_pda/module_pallet/unbundle/components/unbundle_pallet_product_list.dart';
import 'package:hz_xg_pda/module_pallet/unbundle/components/unbundle_pallet_step_indicator.dart';
import 'package:hz_xg_pda/module_pallet/unbundle/components/unbundle_pallet_total_count.dart';
import 'package:hz_xg_pda/module_pallet/unbundle/state/unbundle_pallet_state.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';

class UnbundlePalletPage extends StatefulWidget {
  const UnbundlePalletPage({super.key});

  @override
  State<UnbundlePalletPage> createState() => _UnbundlePalletPageState();
}

class _UnbundlePalletPageState extends State<UnbundlePalletPage> {
  StreamSubscription<String>? _scanSubscription;
  late final UnbundlePalletState _palletState;

  @override
  void initState() {
    super.initState();
    _palletState = UnbundlePalletState();
    _scanSubscription = PdaUtil().onScanResult.listen((result) {
      _palletState.loadPallet(result);
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
        child: UnbundlePalletScope(
          notifier: _palletState,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: const _UnbundlePalletBody(),
          ),
        ),
      ),
    );
  }
}

class _UnbundlePalletBody extends StatelessWidget {
  const _UnbundlePalletBody();

  @override
  Widget build(BuildContext context) {
    final state = NotifierScope.watch<UnbundlePalletState>(context);

    return Column(
      children: [
        AppBackBar(
          onTap: () => Navigator.of(context).maybePop(),
        ),
        const SizedBox(height: 6),
        const UnbundlePalletStepIndicator(),
        const SizedBox(height: 14),
        if (state.palletNo != null) _PalletNoCard(palletNo: state.palletNo!),
        if (state.palletNo != null) const SizedBox(height: 12),
        const UnbundlePalletTotalCount(),
        const SizedBox(height: 14),
        const Expanded(
          child: SingleChildScrollView(
            child: UnbundlePalletProductList(),
          ),
        ),
        const SizedBox(height: 12),
        const UnbundlePalletConfirmBar(),
      ],
    );
  }
}

class _PalletNoCard extends StatelessWidget {
  const _PalletNoCard({required this.palletNo});

  final String palletNo;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0E9),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFFFD9C4)),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.inventory_2_outlined,
            size: 20,
            color: Color(0xFFE86B3C),
          ),
          const SizedBox(width: 10),
          const Text(
            '当前托盘：',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF9AA3B8),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              palletNo,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
          ),
          TextButton(
            onPressed: () => NotifierScope.read<UnbundlePalletState>(context)
                .clear(),
            child: const Text(
              '清除',
              style: TextStyle(
                color: Color(0xFFE86B3C),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
