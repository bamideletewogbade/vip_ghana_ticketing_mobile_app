// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class FilterOptions extends StatefulWidget {
  final Function(String, double, double) onFilterChanged;

  FilterOptions({super.key, required this.onFilterChanged});

  @override
  _FilterOptionsState createState() => _FilterOptionsState();
}

class _FilterOptionsState extends State<FilterOptions> {
  String busType = 'All';
  double minPrice = 0.0;
  double maxPrice = 1000.0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownButton<String>(
          value: busType,
          items: ['All', 'AC', 'Non-AC'].map((String type) {
            return DropdownMenuItem<String>(
              value: type,
              child: Text(type),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              busType = value!;
            });
            widget.onFilterChanged(busType, minPrice, maxPrice);
          },
        ),
        RangeSlider(
          activeColor: Colors.red,
          inactiveColor: Colors.grey,
          values: RangeValues(minPrice, maxPrice),
          min: 0,
          max: 1000,
          divisions: 100,
          labels: RangeLabels('\$${minPrice.toStringAsFixed(0)}',
              '\$${maxPrice.toStringAsFixed(0)}'),
          onChanged: (RangeValues values) {
            setState(() {
              minPrice = values.start;
              maxPrice = values.end;
            });
            widget.onFilterChanged(busType, minPrice, maxPrice);
          },
        ),
      ],
    );
  }
}
