// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/models/bus.dart';
import 'package:vip_bus_ticketing_system/models/ticket.dart';
import 'package:vip_bus_ticketing_system/screens/payment_screen.dart';


class BookingTicketScreen extends StatefulWidget {
  final Bus bus;

  const BookingTicketScreen({Key? key, required this.bus}) : super(key: key);

  @override
  _BookingTicketScreenState createState() => _BookingTicketScreenState();
}

class _BookingTicketScreenState extends State<BookingTicketScreen> {
  final _formKey = GlobalKey<FormState>();
  int _numPassengers = 1;
  late double _totalPrice;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nextOfKinNameController = TextEditingController();
  final TextEditingController _nextOfKinPhoneNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _totalPrice = widget.bus.price * _numPassengers;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _nextOfKinNameController.dispose();
    _nextOfKinPhoneNumberController.dispose();
    super.dispose();
  }

  void _updateTotalPrice(int numPassengers) {
    setState(() {
      _numPassengers = numPassengers;
      _totalPrice = widget.bus.price * _numPassengers;
    });
  }

  void _showTicketDetailsDialog(
      Ticket ticket,
      String userName,
      String userPhoneNumber,
      String nextOfKinName,
      String nextOfKinPhoneNumber) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ticket Details'),
          content: SingleChildScrollView(
            child: _buildTicketCard(ticket, userName, userPhoneNumber,
                nextOfKinName, nextOfKinPhoneNumber),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Proceed',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(),
                  ),
                );
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateAvailableSeats() async {
    try {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentReference busRef =
            FirebaseFirestore.instance.collection('buses').doc(widget.bus.id);
        DocumentSnapshot busSnapshot = await transaction.get(busRef);

        if (!busSnapshot.exists) {
          throw Exception("Bus does not exist!");
        }

        int currentAvailableSeats = busSnapshot['availableSeats'];
        if (currentAvailableSeats < _numPassengers) {
          throw Exception("Not enough seats available!");
        }

        transaction.update(
            busRef, {'availableSeats': currentAvailableSeats - _numPassengers});
      });
    } catch (e) {
      print("Failed to update seats: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text('Failed to update available seats. Please try again.')));
    }
  }

  int _generateRandomSeatNumber(int totalSeats) {
    Random random = Random();
    return random.nextInt(totalSeats) + 1;
  }

  void _onPayWithMomoPressed() async {
    print("Pay with Momo button pressed...");
    if (_formKey.currentState!.validate()) {
      if (_numPassengers > widget.bus.availableSeats) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Not enough seats available.')));
        return;
      }

      _formKey.currentState!.save();
      await _updateAvailableSeats();

      int seatNumber = _generateRandomSeatNumber(widget.bus.availableSeats);

      Ticket ticket = Ticket(
        ticketNumber: '123456', // Generate or fetch actual ticket number
        destination: widget.bus.arrivalStation,
        date: widget.bus.departureTime,
        session: widget.bus.session,
        seatNumber: seatNumber,
        price: _totalPrice.toInt(),
        status: PaymentStatus.pending,
      );
      _showTicketDetailsDialog(
          ticket,
          _nameController.text,
          _phoneController.text,
          _nextOfKinNameController.text,
          _nextOfKinPhoneNumberController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Ticket'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                child: Card(
                  margin: EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
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
                        Text('Price per Ticket: GHS${widget.bus.price}'),
                        Text('Available Seats: ${widget.bus.availableSeats}'),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Details',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: 'Number of Passengers',
                            prefixIconColor: Colors.redAccent,
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.people),
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                int.parse(value) <= 0) {
                              return 'Please enter a valid number of passengers';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            int? numPassengers = int.tryParse(value);
                            if (numPassengers != null && numPassengers > 0) {
                              _updateTotalPrice(numPassengers);
                            }
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _nameController,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIconColor: Colors.redAccent,
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person),
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _phoneController,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefixIconColor: Colors.redAccent,
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone),
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _nextOfKinNameController,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            labelText: 'Next of Kin Name',
                            prefixIconColor: Colors.redAccent,
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person_outline),
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter next of kin name';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 8),
                        TextFormField(
                          controller: _nextOfKinPhoneNumberController,
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                            labelText: 'Next of Kin Phone Number',
                            prefixIconColor: Colors.redAccent,
                            hintStyle: TextStyle(color: Colors.grey),
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.phone_outlined),
                            floatingLabelStyle: TextStyle(color: Colors.black),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                              borderSide: BorderSide(color: Colors.redAccent),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter next of kin phone number';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Price: GHS${_totalPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(
                                      Colors.redAccent),
                            ),
                            onPressed: () {
                              print("Proceeding to payment...");
                              _onPayWithMomoPressed();
                              print('done');
                            },
                            child: Text('Pay with Momo'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ticket Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Ticket Number: ${ticket.ticketNumber}'),
        Text('Destination: ${ticket.destination}'),
        Text('Date: ${ticket.date}'),
        Text('Session: ${ticket.session}'),
        Text('Seat Number: ${ticket.seatNumber}'),
        Text('Price: GHS${ticket.price}'),
        Text('Status: ${ticket.status}'),
        SizedBox(height: 16),
        Text(
          'User Details',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        Text('Full Name: $userName'),
        Text('Phone Number: $userPhoneNumber'),
        Text('Next of Kin Name: $nextOfKinName'),
        Text('Next of Kin Phone Number: $nextOfKinPhoneNumber'),
      ],
    );
  }
}
