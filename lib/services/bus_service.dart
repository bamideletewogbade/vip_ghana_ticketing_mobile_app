import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vip_bus_ticketing_system/models/bus.dart';

class BusService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Bus>> getBuses() {
    return _db.collection('buses').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Bus.fromFirestore(doc)).toList());
  }

  // Fetch buses based on search criteria
  Future<List<Bus>> fetchBuses(String from, String to, String session) async {
    QuerySnapshot snapshot = await _db
        .collection('buses')
        .where('departureStation', isEqualTo: from)
        .where('arrivalStation', isEqualTo: to)
        .where('session', isEqualTo: session)
        .get();

    return snapshot.docs.map((doc) => Bus.fromFirestore(doc)).toList();
  }

  Future<void> addBusData() async {
    CollectionReference buses = _db.collection('buses');

    List<Map<String, dynamic>> busList = [
      {
        "departureTime": "2024-06-15 08:30",
        "arrivalTime": "2024-06-15 12:00",
        "busType": "AC",
        "price": 35.50,
        "availableSeats": 20,
        "departureStation": "Accra",
        "arrivalStation": "Sunyani",
        'session': 'Morning',
      },
      {
        "departureTime": "2024-06-15 09:00",
        "arrivalTime": "2024-06-15 13:30",
        "busType": "Non-AC",
        "price": 25.00,
        "availableSeats": 15,
        "departureStation": "Kumasi",
        "arrivalStation": "Accra",
        'session': 'Evening',
      },
      {
        "departureTime": "2024-06-15 10:00",
        "arrivalTime": "2024-06-15 14:00",
        "busType": "AC",
        "price": 40.00,
        "availableSeats": 10,
        "departureStation": "Cape Coast",
        "arrivalStation": "Tema",
        'session': 'Morning',
      },
      {
        "departureTime": "2024-06-15 11:00",
        "arrivalTime": "2024-06-15 15:30",
        "busType": "Non-AC",
        "price": 30.00,
        "availableSeats": 5,
        "departureStation": "Kumasi",
        "arrivalStation": "Sunyani",
        'session': 'Evening',
      },
      {
        "departureTime": "2024-06-15 12:00",
        "arrivalTime": "2024-06-15 16:00",
        "busType": "AC",
        "price": 50.00,
        "availableSeats": 8,
        "departureStation": "Accra",
        "arrivalStation": "Tema"
      },
      // Add more bus entries as needed
    ];

    for (var bus in busList) {
      await buses.add(bus);
    }
  }
}
