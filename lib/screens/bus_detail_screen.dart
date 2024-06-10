// bus_details_screen.dart

import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/models/bus.dart';

class BusDetailsScreen extends StatelessWidget {
  final Bus bus;

  BusDetailsScreen({required this.bus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Details'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bus Type: ${bus.busType}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Departure Station: ${bus.departureStation}'),
            Text('Arrival Station: ${bus.arrivalStation}'),
            Text('Departure Time: ${bus.departureTime}'),
            Text('Arrival Time: ${bus.arrivalTime}'),
            Text('Price: GHS${bus.price}'),
            Text('Available Seats: ${bus.availableSeats}'),
            // Add more detailed bus info as needed
            SizedBox(height: 20),
            Text(
              'Enter number of passengers:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Add form fields for trip details (e.g., number of passengers)
          ],
        ),
      ),
    );
  }
}
