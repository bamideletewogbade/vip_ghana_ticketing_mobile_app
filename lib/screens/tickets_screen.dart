import 'package:flutter/material.dart';
import 'ticket_details_screen.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsScreen> {
  // Sample list of tickets (you can replace this with your actual data)
  final List<Ticket> tickets = [
    Ticket(
      ticketNumber: 'ABC123',
      destination: 'New York',
      date: 'May 31, 2024',
      time: '10:00 AM',
      status: TicketStatus.confirmed,
    ),
    Ticket(
      ticketNumber: 'DEF456',
      destination: 'Los Angeles',
      date: 'June 5, 2024',
      time: '12:00 PM',
      status: TicketStatus.pending,
    ),
    Ticket(
      ticketNumber: 'GHI789',
      destination: 'Chicago',
      date: 'June 10, 2024',
      time: '3:00 PM',
      status: TicketStatus.cancelled,
    ),
  ];

  // Sample list of recent trips
  final List<Trip> recentTrips = [
    Trip(
      departure_terminal: 'Accra',
      destination_terminal: 'Sunyani',
      date: 'April 15, 2024',
      departure_time: '9:00 PM',
    ),
    Trip(
      departure_terminal: 'Kumasi',
      destination_terminal: 'Sunyani',
      date: 'April 15, 2024',
      departure_time: '9:00 PM',
    ),
    Trip(
      departure_terminal: 'Accra',
      destination_terminal: 'Cape Coast',
      date: 'April 15, 2024',
      departure_time: '9:00 PM',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tickets'),
      ),
      body: ListView(
        children: <Widget>[
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              return _buildTicketCard(tickets[index]);
            },
          ),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Recent Trips',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: recentTrips.length,
            itemBuilder: (context, index) {
              return _buildTripCard(recentTrips[index]);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTicketCard(Ticket ticket) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(ticket.destination),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Date: ${ticket.date}'),
            Text('Time: ${ticket.time}'),
            Text('Status: ${ticket.statusToString()}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to ticket details screen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TicketDetailsScreen(ticket: ticket),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTripCard(Trip trip) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        title: Text(trip.destination_terminal),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Date: ${trip.date}',
            ),
            Text(
              'Departure Terminal: ${trip.departure_time}',
            ),
          ],
        ),
      ),
    );
  }
}

// Model class for Ticket
class Ticket {
  final String ticketNumber;
  final String destination;
  final String date;
  final String time;
  final TicketStatus status;

  Ticket({
    required this.ticketNumber,
    required this.destination,
    required this.date,
    required this.time,
    required this.status,
  });

  String statusToString() {
    switch (status) {
      case TicketStatus.confirmed:
        return 'Confirmed';
      case TicketStatus.pending:
        return 'Pending';
      case TicketStatus.cancelled:
        return 'Cancelled';
    }
  }
}

// Model class for Trip
class Trip {
  final String destination_terminal;
  final String departure_terminal;
  final String date;
  final String departure_time;

  Trip({
    required this.destination_terminal,
    required this.departure_terminal,
    required this.date,
    required this.departure_time,
  });
}

// Enum for Ticket Status
enum TicketStatus { confirmed, pending, cancelled }
