import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/models/bus.dart';
import 'package:vip_bus_ticketing_system/screens/filter_options.dart';
import 'package:vip_bus_ticketing_system/screens/sort_options.dart';
import 'package:vip_bus_ticketing_system/services/bus_service.dart';

class SearchResultsScreen extends StatefulWidget {
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
      appBar: AppBar(title: Text('Available Buses')),
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
                      title: Text('${bus.departureTime} - ${bus.arrivalTime}'),
                      subtitle: Text(
                          '${bus.busType}, \$${bus.price}, Seats: ${bus.availableSeats}'),
                      onTap: () {
                        // Handle bus selection
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
}
