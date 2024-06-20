import 'package:flutter/material.dart';

class TicketManagementScreen extends StatefulWidget {
  @override
  State<TicketManagementScreen> createState() => _BusManagementScreenState();
}

class _BusManagementScreenState extends State<TicketManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Ticket Management',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}