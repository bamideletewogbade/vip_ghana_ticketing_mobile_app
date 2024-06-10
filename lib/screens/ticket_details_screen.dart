// ticket_details_screen.dart

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
            Text(
              'Ticket Number: ${ticket.ticketNumber}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Destination: ${ticket.destination}'),
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
            // Add any additional UI components like text fields for passenger details, buttons, etc.
          ],
        ),
      ),
    );
  }

  String _getStatusText(int? status) {
    switch (status) {
      case TicketStatus.confirmed:
        return 'Confirmed';
      case TicketStatus.pending:
        return 'Pending';
      case TicketStatus.cancelled:
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }

  Color _getStatusColor(int? status) {
    switch (status) {
      case TicketStatus.confirmed:
        return Colors.green;
      case TicketStatus.pending:
        return Colors.orange;
      case TicketStatus.cancelled:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
