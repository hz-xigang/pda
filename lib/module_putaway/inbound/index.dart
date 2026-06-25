import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hz_xg_pda/components/app_back_bar.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/inbound_confirm_bar.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/inbound_location_section.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/inbound_product_list.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/inbound_step_indicator.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/inbound_total_count.dart';
import 'package:hz_xg_pda/module_putaway/inbound/state/inbound_state.dart';
import 'package:hz_xg_pda/util/PdaUtil.dart';

class InboundPage extends StatefulWidget {
  const InboundPage({super.key});

  @override
  State<InboundPage> createState() => _InboundPageState();
}

class _InboundPageState extends State<InboundPage> {
  StreamSubscription<String>? _scanSubscription;
  late final InboundState _state;

  @override
  void initState() {
    super.initState();
    _state = InboundState();
    _scanSubscription = PdaUtil().onScanResult.listen((result) {
      _state.onScanProduct(result, context);
    });

    _state.initLocList();

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
        child: InboundScope(
          notifier: _state,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
            child: const _InboundBody(),
          ),
        ),
      ),
    );
  }
}

class _InboundBody extends StatelessWidget {
  const _InboundBody();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBackBar(onTap: () => Navigator.pop(context)),
        const SizedBox(height: 12),
        const InboundStepIndicator(),
        const SizedBox(height: 12),
        const Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 12),
                InboundTotalCount(),
                SizedBox(height: 16),
                InboundProductList(),
                SizedBox(height: 16),
                InboundLocationSection(),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        const InboundConfirmBar(),
      ],
    );
  }
}
