import 'package:flutter/material.dart';

class FilterChipWidget extends StatelessWidget {
  final String label;
  final VoidCallback onDeleted;

  const FilterChipWidget({
    super.key,
    required this.label,
    required this.onDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4.0),
      child: Chip(
        backgroundColor: Colors.white,
        label: Text(label),
        onDeleted: onDeleted,
      ),
    );
  }
}