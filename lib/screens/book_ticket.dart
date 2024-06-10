// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/models/bus.dart';

class BookingTicketScreen extends StatefulWidget {
  final Bus bus;

  const BookingTicketScreen({Key? key, required this.bus}) : super(key: key);

  @override
  _BookingTicketScreenState createState() => _BookingTicketScreenState();
}

class _BookingTicketScreenState extends State<BookingTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  int _numPassengers = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Ticket'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bus Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text('Bus Type: ${widget.bus.busType}'),
              Text('Departure: ${widget.bus.departureStation}'),
              Text('Arrival: ${widget.bus.arrivalStation}'),
              Text('Departure Time: ${widget.bus.departureTime}'),
              Text('Price: GHS${widget.bus.price}'),
              SizedBox(height: 16),
              Text(
                'Booking Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                cursorColor: Colors.black,
                decoration: const InputDecoration(
                  labelText: 'Enter number of passengers',
                  labelStyle: TextStyle(
                    color: Colors.redAccent,
                  ),
                  prefixIconColor: Colors.redAccent,
                  // hintText: 'Enter the number of passengers',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person_2_outlined),
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: Colors.redAccent),
                  ),
                ),
                obscureText: true,
                keyboardType: TextInputType.number,
                initialValue: _numPassengers.toString(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of passengers';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid number of passengers';
                  }
                  return null;
                },
                onSaved: (value) {
                  _numPassengers = int.parse(value!);
                },
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      // Proceed with the booking logic
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                              'Booking $_numPassengers tickets for ${widget.bus.departureStation} to ${widget.bus.arrivalStation}'),
                        ),
                      );
                      // Add booking logic here

                      // Add payment methods logic
                    }
                  },
                  child: Text('Confirm Booking'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.redAccent,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
