// ignore_for_file: prefer_final_fields, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/models/bus.dart';

class SeatSelectionScreen extends StatefulWidget {
  final Bus bus;
  final int numPassengers;

  const SeatSelectionScreen(
      {Key? key, required this.bus, required this.numPassengers})
      : super(key: key);

  @override
  _SeatSelectionScreenState createState() => _SeatSelectionScreenState();
}

class _SeatSelectionScreenState extends State<SeatSelectionScreen> {
  List<int> _selectedSeats = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nextOfKinNameController =
      TextEditingController();
  final TextEditingController _nextOfKinPhoneNumberController =
      TextEditingController();
  List<TextEditingController> _passengerNameControllers = [];

  @override
  void initState() {
    super.initState();
    _nameController;
    for (int i = 0; i < widget.numPassengers - 1; i++) {
      _passengerNameControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nextOfKinNameController.dispose();
    _nextOfKinPhoneNumberController.dispose();
    super.dispose();
  }

  void _toggleSeatSelection(int seatNumber) {
    setState(() {
      if (_selectedSeats.contains(seatNumber)) {
        _selectedSeats.remove(seatNumber);
      } else {
        if (_selectedSeats.length < widget.numPassengers) {
          _selectedSeats.add(seatNumber);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('You can only select ${widget.numPassengers} seats'),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User details'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              // key: UniqueKey(),
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Enter your name',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.redAccent,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              // key: UniqueKey(),
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone number',
                hintText: 'Enter your phone number',
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.redAccent,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              // key: UniqueKey(),
              controller: _nextOfKinNameController,
              decoration: InputDecoration(
                labelText: 'Next of kin name',
                hintText: 'Enter the name of your next of kin',
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.redAccent,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              // key: UniqueKey(),
              controller: _nextOfKinPhoneNumberController,
              decoration: InputDecoration(
                labelText: 'Next of kin phone number',
                hintText: 'Enter your next of kin\'s phone number',
                prefixIcon: Icon(
                  Icons.phone,
                  color: Colors.redAccent,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
            ),
            // Text('Enter passenger names:'),
            // TextFormField(
            //   controller: _nameController,
            //   decoration: InputDecoration(
            //     labelText: 'Passenger 1 Name',
            //     prefixIcon: Icon(Icons.person),
            //   ),
            // ),
            // for (int i = 0; i < _passengerNameControllers.length; i++)
            //   TextFormField(
            //     controller: _passengerNameControllers[i],
            //     decoration: InputDecoration(
            //       labelText: 'Passenger ${i + 2} Name',
            //       prefixIcon: Icon(Icons.person),
            //     ),
            //   ),
            SizedBox(height: 16),
            // Expanded(
            //   child: GridView.builder(
            //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            //       crossAxisCount: 4,
            //       childAspectRatio: 1,
            //       crossAxisSpacing: 20,
            //       mainAxisSpacing: 1,
            //     ),
            //     itemCount: widget.bus.availableSeats,
            //     itemBuilder: (context, index) {
            //       return GestureDetector(
            //         onTap: () => _toggleSeatSelection(index + 1),
            //         child: Container(
            //           decoration: BoxDecoration(
            //             color: _selectedSeats.contains(index + 1)
            //                 ? Colors.redAccent
            //                 : Colors.grey[300],
            //             borderRadius: BorderRadius.circular(8.0),
            //             border: Border.all(color: Colors.black),
            //           ),
            //           child: Center(
            //             child: Text(
            //               '${index + 1}',
            //               style: TextStyle(
            //                 color: _selectedSeats.contains(index + 1)
            //                     ? Colors.white
            //                     : Colors.black,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
