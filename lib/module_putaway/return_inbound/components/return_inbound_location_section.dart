import 'package:flutter/material.dart';
import 'package:hz_xg_pda/module_putaway/base/components/base_putaway_location_section.dart';
import 'package:hz_xg_pda/module_putaway/return_inbound/state/return_inbound_state.dart';

class ReturnInboundLocationSection extends StatelessWidget {
  const ReturnInboundLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = ReturnInboundScope.watch(context);

    return BasePutawayLocationSection(
      accentColor: const Color(0xFFFF4D5E),
      selectedLocation: state.selectedLocation,
      locationOptions: state.locationOptions,
      onChanged: state.updateLocation,
      title: '目标库位',
      label: '库位',
    );
  }
}
