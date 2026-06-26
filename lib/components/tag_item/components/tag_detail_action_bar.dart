import 'package:flutter/material.dart';

class TagDetailActionBar extends StatelessWidget {
  const TagDetailActionBar({
    super.key,
    required this.onDeleteSelected,
    required this.onDeleteAll,
  });

  final VoidCallback onDeleteSelected;
  final VoidCallback onDeleteAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onDeleteSelected,
              icon: const Icon(Icons.delete_outline_rounded, size: 20),
              label: const Text(
                '删除',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFE54B4B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 52,
            child: ElevatedButton.icon(
              onPressed: onDeleteAll,
              icon: const Icon(Icons.delete_forever_outlined, size: 20),
              label: const Text(
                '删除全部',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              style: ElevatedButton.styleFrom(
                elevation: 0,
                foregroundColor: Colors.white,
                backgroundColor: const Color(0xFFE54B4B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
