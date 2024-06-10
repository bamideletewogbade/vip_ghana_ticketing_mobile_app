import 'package:cloud_firestore/cloud_firestore.dart';

class Bus {
  final String id;
  final String departureTime;
  final String arrivalTime;
  final String busType;
  final double price;
  final int availableSeats;
  final String departureStation;
  final String arrivalStation;

  String get departureDate => departureTime.split(' ')[0];
  String get departureTimeOnly => departureTime.split(' ')[1];

  Bus({
    required this.id,
    required this.departureTime,
    required this.arrivalTime,
    required depatureDate,
    required this.busType,
    required this.price,
    required this.availableSeats,
    required this.departureStation,
    required this.arrivalStation,
  });

  factory Bus.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Bus(
      id: doc.id,
      departureTime: data['departureTime'] ?? '',
      arrivalTime: data['arrivalTime'] ?? '',
      depatureDate: data['departureDate'] ?? '',
      busType: data['busType'] ?? '',
      price: data['price']?.toDouble() ?? 0.0,
      availableSeats: data['availableSeats'] ?? 0,
      departureStation: data['departureStation'] ?? '',
      arrivalStation: data['arrivalStation'] ?? '',
    );
  }
}
