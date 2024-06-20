// ignore_for_file: prefer_const_constructors

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/models/bus.dart';
import 'package:vip_bus_ticketing_system/models/ticket.dart';

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
  final TextEditingController _nextOfKinNameController =
      TextEditingController();
  final TextEditingController _nextOfKinPhoneNumberController =
      TextEditingController();

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

  void _showPaymentDialog(BuildContext context) {
    String mobileNumber = '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Payment Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Enter Mobile Number'),
                onChanged: (value) {
                  mobileNumber = value;
                },
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Proceed',
                style: TextStyle(color: Colors.redAccent),
              ),
              onPressed: () {
                // Handle the payment logic here
                _makePayment(mobileNumber);
                Scaffold();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _makePayment(String mobileNumber) {
    // Add your payment logic here
    // This method will be called when the user clicks on the "Proceed" button
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
                _showPaymentDialog(context);
                Navigator.of(context).pop();
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
    if (_formKey.currentState!.validate()) {
      if (_numPassengers > widget.bus.availableSeats) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Changed here.')));
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
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                          labelText: 'Enter number of passengers',
                          prefixIconColor: Colors.redAccent,
                          // hintText: '*********',
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
                          keyboardType: TextInputType.number,  
                          initialValue: _numPassengers.toString(),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the number of passengers';
                            }
                            if (int.tryParse(value) == null ||
                                int.parse(value) <= 0) {
                              return 'Please enter a valid number of passengers';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            _updateTotalPrice(int.parse(value));
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                          labelText: 'Enter your name',
                          prefixIconColor: Colors.redAccent,
                          // hintText: '*********',
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
                          keyboardType: TextInputType.name,  
                          // initialValue: _numPassengers.toString(),
                          // validator: (value) {
                          //   if (value == null || value.isEmpty) {
                          //     return 'Please enter the number of passengers';
                          //   }
                          //   if (int.tryParse(value) == null ||
                          //       int.parse(value) <= 0) {
                          //     return 'Please enter a valid number of passengers';
                          //   }
                          //   return null;
                          // },
                          // onChanged: (value) {
                          //   _updateTotalPrice(int.parse(value));
                          // },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                          labelText: 'Enter your phone number',
                          prefixIconColor: Colors.redAccent,
                          // hintText: '*********',
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
                          keyboardType: TextInputType.phone,  
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                          labelText: 'Name of next of kin',
                          prefixIconColor: Colors.redAccent,
                          // hintText: '*********',
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
                          keyboardType: TextInputType.name,      
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          cursorColor: Colors.black,
                          decoration: const InputDecoration(
                          labelText: 'Next of kin phone number',
                          prefixIconColor: Colors.redAccent,
                          // hintText: '*********',
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
                          keyboardType: TextInputType.phone,  
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Total Price: GHS$_totalPrice',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _onPayWithMomoPressed,
                          child: Text('Pay with Momo'),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
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
    return Card(
      margin: const EdgeInsets.all(10.0),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ticket Number: ${ticket.ticketNumber}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text('Date: ${ticket.date}'),
            SizedBox(height: 10),
            Text('Name: $userName'),
            Text('Phone number: $userPhoneNumber'),
            Text('Destination Terminal: ${ticket.destination}'),
            // Text('Departure Terminal: ${ticket.departure}'),

            // Text('Session: ${ticket.session}'),
            Text('Price: GHS${ticket.price}'),
            Text('Seat Number: ${ticket.seatNumber}'),
            // Text(
            //   'Status: ${_getStatusText(ticket.status)}',
            //   style: TextStyle(
            //     color: _getStatusColor(ticket.status),
            //   ),
            // ),
            // SizedBox(height: 10),

            // Text('Next of Kin Name: $nextOfKinName'),
            // Text('Next of Kin Phone Number: $nextOfKinPhoneNumber'),
            // Add any additional UI components like text fields for passenger details, buttons, etc.
          ],
        ),
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
