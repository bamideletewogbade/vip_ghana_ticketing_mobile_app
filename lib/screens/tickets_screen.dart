// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vip_bus_ticketing_system/models/bus.dart';
import 'package:vip_bus_ticketing_system/services/bus_service.dart';

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({super.key});

  @override
  _TicketsPageState createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsScreen> {
  final BusService _busService = BusService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Buses'),
        backgroundColor: Colors.redAccent,
      ),
      body: StreamBuilder<List<Bus>>(
        stream: _busService.getBuses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No buses available'));
          }

          final buses = snapshot.data!;
          return ListView.builder(
            itemCount: buses.length,
            itemBuilder: (context, index) {
              final bus = buses[index];
              return _buildBusCard(bus);
            },
          );
        },
      ),
    );
  }

  Widget _buildBusCard(Bus bus) {
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: ListTile(
        title: Text('${bus.departureStation} to ${bus.arrivalStation}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Departure: ${bus.departureTime}'),
            Text('Arrival: ${bus.arrivalTime}'),
            Text('Bus Type: ${bus.busType}'),
            Text('Price: \GHS${bus.price.toStringAsFixed(2)}'),
            Text('Available Seats: ${bus.availableSeats}'),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          // Navigate to bus details screen or booking screen
          // Navigator.push(context, MaterialPageRoute(builder: (context) => BusDetailsScreen(bus: bus)));
        },
      ),
    );
  }
}
