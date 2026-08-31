import 'package:flutter/material.dart';
import 'package:hz_xg_pda/state/notifier_scope.dart';
import 'package:hz_xg_pda/module_putaway/base/components/base_putaway_location_section.dart';
import 'package:hz_xg_pda/module_putaway/inbound/state/inbound_state.dart';

class InboundLocationSection extends StatelessWidget {
  const InboundLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = NotifierScope.watch<InboundState>(context);

    return BasePutawayLocationSection(
      accentColor: const Color(0xFF18A8F1),
      selectedLocation: state.selectedLocation,
      locationOptions: state.locationOptions,
      onChanged: state.updateLocation,
    );
  }
}
