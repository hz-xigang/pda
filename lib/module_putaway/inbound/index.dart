import 'package:flutter/material.dart';
import 'package:hz_xg_pda/module_putaway/base/base_putaway_page.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/inbound_confirm_bar.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/inbound_location_section.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/inbound_product_list.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/inbound_step_indicator.dart';
import 'package:hz_xg_pda/module_putaway/inbound/components/inbound_total_count.dart';
import 'package:hz_xg_pda/module_putaway/inbound/state/inbound_state.dart';

class InboundPage extends StatelessWidget {
  const InboundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BasePutawayPage<InboundState>(
      createNotifier: InboundState.new,
      scopeBuilder: (state, child) => InboundScope(
        notifier: state,
        child: child,
      ),
      onScan: (state, result, context) => state.onScanProduct(result, context),
      child: const BasePutawayBody(
        stepIndicator: InboundStepIndicator(),
        totalCount: InboundTotalCount(),
        productList: InboundProductList(),
        locationSection: InboundLocationSection(),
        confirmBar: InboundConfirmBar(),
      ),
    );
  }
}
