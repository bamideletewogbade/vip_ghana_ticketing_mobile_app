// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class SortOptions extends StatefulWidget {
  final Function(String) onSortChanged;

  SortOptions({super.key, required this.onSortChanged});

  @override
  _SortOptionsState createState() => _SortOptionsState();
}

class _SortOptionsState extends State<SortOptions> {
  String sortOption = 'Price';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: sortOption,
      items: ['Price', 'Duration', 'Departure Time'].map((String option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          sortOption = value!;
        });
        widget.onSortChanged(sortOption);
      },
    );
  }
}
