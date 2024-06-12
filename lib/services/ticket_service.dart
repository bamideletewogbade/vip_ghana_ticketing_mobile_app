import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vip_bus_ticketing_system/models/ticket.dart';

class TicketService {
  final CollectionReference _ticketCollection =
      FirebaseFirestore.instance.collection('tickets');

  Future<void> saveTicket(Ticket ticket) async {
    try {
      await _ticketCollection.add(ticket.toMap());
      print('Ticket saved successfully');
    } catch (e) {
      print('Failed to save ticket: $e');
    }
  }
}
