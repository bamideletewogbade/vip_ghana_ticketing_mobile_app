import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/screens/splash_screen.dart';

void main() {
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
