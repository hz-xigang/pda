import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/pallet_inbound_confirm_bar.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/pallet_inbound_location_section.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/pallet_inbound_product_list.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/pallet_inbound_step_indicator.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/pallet_inbound_total_count.dart';
import 'package:hz_xg_pda/module_putaway/inbound/state/pallet_inbound_state.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';

class PalletInboundPage extends StatefulWidget {
  const PalletInboundPage({super.key});

  @override
  State<PalletInboundPage> createState() => _PalletInboundPageState();
}

class _PalletInboundPageState extends State<PalletInboundPage> {
  StreamSubscription<String>? _scanSubscription;
  late final PalletInboundState _state;

  @override
  void initState() {
    super.initState();
    _state = PalletInboundState();
    _scanSubscription = PdaUtil().onScanResult.listen((result) {
      _state.onScanProduct(result, context);
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
        child: PalletInboundScope(
          notifier: _state,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: const _PalletInboundBody(),
          ),
        ),
      ),
    );
  }
}

class _PalletInboundBody extends StatelessWidget {
  const _PalletInboundBody();

  @override
  Widget build(BuildContext context) {
    final state = PalletInboundScope.watch(context);

    return Column(
      children: [
        AppBackBar(onTap: () => Navigator.pop(context)),
        const SizedBox(height: 12),
        PalletInboundStepIndicator(currentStep: state.currentStep),
        const SizedBox(height: 12),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 12),
                PalletInboundTotalCount(count: state.totalCount),
                const SizedBox(height: 16),
                PalletInboundProductList(products: state.products),
                const SizedBox(height: 16),
                PalletInboundLocationSection(
                  locations: state.locationOptions,
                  selectedLocation: state.selectedLocation,
                  onChanged: state.updateLocation,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        PalletInboundConfirmBar(
          onConfirm: () => state.confirmInbound(context),
        ),
      ],
    );
  }
}
