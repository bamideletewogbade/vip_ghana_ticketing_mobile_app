// ticket_model.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  Ticket({
    this.ticketNumber,
    this.destination,
    this.date,
    this.session,
    this.price,
    this.seatNumber,
    this.status,
  });

  String? ticketNumber;
  String? destination;
  String? date;
  String? session;
  int? seatNumber;
  int? price;
  int? status;

  factory Ticket.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Ticket(
      ticketNumber: data['ticketNumber'] ?? '',
      destination: data['destination'] ?? '',
      date: data['date'] ?? '',
      session: data['session'] ?? '',
      seatNumber: data['seatNumber'] ?? 0,
      price: data['price'] ?? 0,
      status: data['status'] ?? TicketStatus.pending,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'ticketNumber': ticketNumber,
      'destination': destination,
      'date': date,
      'session': session,
      'seatNumber': seatNumber,
      'price': price,
      'status': status,
    };
  }
}

class TicketStatus {
  static const int confirmed = 0;
  static const int pending = 1;
  static const int cancelled = 2;
}
