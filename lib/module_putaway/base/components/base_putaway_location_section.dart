import 'package:flutter/material.dart';
import 'package:hz_xg_pda/entity/loc_archive.dart';

class BasePutawayLocationSection extends StatelessWidget {
  const BasePutawayLocationSection({
    super.key,
    required this.accentColor,
    required this.selectedLocation,
    required this.locationOptions,
    required this.onChanged,
    this.title = '目标库位',
    this.label = '库位',
  });

  final Color accentColor;
  final LocArchive? selectedLocation;
  final List<LocArchive> locationOptions;
  final ValueChanged<LocArchive?> onChanged;
  final String title;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                color: accentColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: const TextStyle(
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
              Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  color: Color(0xFF4B5563),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<LocArchive>(
                value: selectedLocation,
                items: locationOptions
                    .map(
                      (item) => DropdownMenuItem<LocArchive>(
                        value: item,
                        child: Text(item.locCode ?? '--'),
                      ),
                    )
                    .toList(growable: false),
                onChanged: onChanged,
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
