import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/loc_archive.dart';
import 'package:hz_xg_pda/module_putaway/inbound/state/inbound_state.dart';

class InboundLocationSection extends StatelessWidget {
  const InboundLocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    final state = InboundScope.watch(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: const BoxDecoration(
                color: Color(0xFF18A8F1),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              '目标库位',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Color(0xFF111827),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: const [
              BoxShadow(
                color: Color(0x12000000),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '库位',
                style: TextStyle(
                  fontSize: 15,
                  color: Color(0xFF4B5563),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<LocArchive>(
                value: state.selectedLocation,
                items: state.locationOptions
                    .map(
                      (item) => DropdownMenuItem<LocArchive>(
                        value: item,
                        child: Text(item.locCode ?? '--'),
                      ),
                    )
                    .toList(growable: false),
                onChanged: state.updateLocation,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFD7DFEC),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: const BorderSide(
                      color: Color(0xFFD7DFEC),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
