// ticket_details_screen.dart

// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/models/ticket.dart';

class TicketDetailsScreen extends StatelessWidget {
  final Ticket ticket;

  TicketDetailsScreen({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Details'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTicketCard(ticket, 'Tewogbade Bamidele', '0597790470', 'Tewa',
                '0595797234'),
            // Add any additional UI components like text fields for passenger details, buttons, etc.
          ],
        ),
      ),
    );
  }

  Widget _buildTicketCard(
      Ticket ticket,
      String userName,
      String userPhoneNumber,
      String nextOfKinName,
      String nextOfKinPhoneNumber) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ticket Number: ${ticket.ticketNumber}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text('Destination Terminal: ${ticket.destination}'),
          Text('Departure Terminal: ${ticket.departure}'),
          Text('Date: ${ticket.date}'),
          Text('Session: ${ticket.session}'),
          Text('Price: GHS\$${ticket.price}'),
          Text('Seat Number: ${ticket.seatNumber}'),
          Text(
            'Status: ${_getStatusText(ticket.status)}',
            style: TextStyle(
              color: _getStatusColor(ticket.status),
            ),
          ),
          SizedBox(height: 10),
          Text('User Name: $userName'),
          Text('User Phone Number: $userPhoneNumber'),
          Text('Next of Kin Name: $nextOfKinName'),
          Text('Next of Kin Phone Number: $nextOfKinPhoneNumber'),
          // Add any additional UI components like text fields for passenger details, buttons, etc.
        ],
      ),
    );
  }

  String _getStatusText(int? status) {
    switch (status) {
      case PaymentStatus.successful:
        return 'Confirmed';
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(int? status) {
    switch (status) {
      case PaymentStatus.successful:
        return Colors.green;
      case PaymentStatus.pending:
        return Colors.orange;
      case PaymentStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
