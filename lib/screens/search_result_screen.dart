// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/models/bus.dart';
import 'package:vip_bus_ticketing_system/screens/book_ticket.dart';
import 'package:vip_bus_ticketing_system/screens/filter_options.dart';
import 'package:vip_bus_ticketing_system/screens/sort_options.dart';
import 'package:vip_bus_ticketing_system/services/bus_service.dart';

class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen(
      {super.key, required this.from, required this.to, required this.session});

  final String from;
  final String to;
  final String session;

  @override
  _SearchResultsScreenState createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  final BusService _busService = BusService();

  String busType = 'All';
  double minPrice = 0.0;
  double maxPrice = 1000.0;
  String sortOption = 'Price';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          alignment: Alignment.center,
          child: Text(
            'Search',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
              fontSize: 24,
            ),
          ),
        ),
        backgroundColor: Colors.redAccent,
      ),
      body: Column(
        children: [
          FilterOptions(
            onFilterChanged: (type, min, max) {
              setState(() {
                busType = type;
                minPrice = min;
                maxPrice = max;
              });
            },
          ),
          SortOptions(
            onSortChanged: (option) {
              setState(() {
                sortOption = option;
              });
            },
          ),
          Expanded(
            child: StreamBuilder<List<Bus>>(
              stream: _busService.getBuses().map((buses) {
                return buses.where((bus) {
                  if (busType != 'All' && bus.busType != busType) return false;
                  if (bus.price < minPrice || bus.price > maxPrice)
                    return false;
                  return true;
                }).toList();
              }).map((buses) {
                if (sortOption == 'Price') {
                  buses.sort((a, b) => a.price.compareTo(b.price));
                } else if (sortOption == 'Duration') {
                  // Implement duration sort logic
                } else if (sortOption == 'Departure Time') {
                  buses.sort(
                      (a, b) => a.departureTime.compareTo(b.departureTime));
                }
                return buses;
              }),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No buses available'));
                }

                final buses = snapshot.data!;
                return ListView.builder(
                  itemCount: buses.length,
                  itemBuilder: (context, index) {
                    final bus = buses[index];
                    return ListTile(
                      title: Text(
                          '${bus.departureStation} - ${bus.arrivalStation}'),
                      subtitle: Text(
                          '${bus.busType}, GHS${bus.price}, Seats: ${bus.availableSeats}'),
                      onTap: () {
                        _showBusDetailsDialog(context, bus);
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showBusDetailsDialog(BuildContext context, Bus bus) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bus Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Bus Type: ${bus.busType}'),
              Text('Departure Station: ${bus.departureStation}'),
              Text('Arrival Station: ${bus.arrivalStation}'),
              Text('Departure Time: ${bus.departureTime}'),
              Text('Arrival Time: ${bus.arrivalTime}'),
              Text('Price: GHS${bus.price}'),
              Text('Available Seats: ${bus.availableSeats}'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Book Ticket'),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingTicketScreen(bus: bus),
                  ),
                );
              },
            ),
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
