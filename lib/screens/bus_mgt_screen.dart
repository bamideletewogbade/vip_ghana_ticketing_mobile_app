import 'package:flutter/material.dart';

class BusManagementScreen extends StatefulWidget {
  @override
  State<BusManagementScreen> createState() => _BusManagementScreenState();
}

class _BusManagementScreenState extends State<BusManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Bus Management',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}