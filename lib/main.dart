import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/screens/splash_screen.dart';
import 'package:vip_bus_ticketing_system/services/bus_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Add bus data for testing
  final BusService busService = BusService();
  busService.addBusData();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VIP Jeoun Bus Ticketing System',
      home: SplashScreen(),
    );
  }
}
