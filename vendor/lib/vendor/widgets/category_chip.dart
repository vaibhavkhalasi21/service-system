import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String title;
  final bool selected;

  const CategoryChip({super.key, required this.title, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Chip(
        label: Text(title),
        backgroundColor: selected ? Colors.blue : Colors.white,
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
