// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vip_bus_ticketing_system/screens/tickets_screen.dart';
import 'package:vip_bus_ticketing_system/screens/profile_screen.dart';
import 'package:vip_bus_ticketing_system/screens/support_screen.dart';
import 'package:geolocator/geolocator.dart';

void main() {
  runApp(MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    HomeContent(),
    TicketsScreen(),
    ProfileScreen(),
    SupportScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    // Hide the status bar
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
  }

  @override
  void dispose() {
    // Restore the status bar when leaving the screen
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Home',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.confirmation_number),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Support',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.redAccent,
        onTap: _onItemTapped,
        selectedLabelStyle: TextStyle(color: Colors.redAccent),
        unselectedLabelStyle: TextStyle(color: Colors.black),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final String username = 'Ife';
  final TextEditingController toController = TextEditingController();
  final TextEditingController fromController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  String nearestTerminal = '';
  GoogleMapController? _mapController;

  // List of VIP bus terminals (example data)
  final List<Map<String, dynamic>> terminals = [
    {'name': 'Accra Terminal', 'latitude': 5.6037, 'longitude': -0.1870},
    {'name': 'Kumasi Terminal', 'latitude': 6.6884, 'longitude': -1.6244},
    {'name': 'Sunyani Terminal', 'latitude': 7.3390, 'longitude': -2.3267},
  ];

  @override
  void initState() {
    super.initState();
    _getNearestTerminal();
  }

  Future<void> _getNearestTerminal() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          nearestTerminal = 'Location permissions are denied';
        });
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        nearestTerminal = 'Location permissions are permanently denied';
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    double minDistance = double.infinity;
    String nearest = '';
    LatLng nearestTerminalLocation = const LatLng(0, 0);

    for (var terminal in terminals) {
      double distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        terminal['latitude'],
        terminal['longitude'],
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearest = terminal['name'];
        nearestTerminalLocation =
            LatLng(terminal['latitude'], terminal['longitude']);
      }
    }

    setState(() {
      nearestTerminal = 'Nearest Terminal: $nearest';
      _mapController?.animateCamera(CameraUpdate.newLatLng(
        nearestTerminalLocation,
      ));
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.redAccent,
              onPrimary: Colors.white,
              surface: Colors.redAccent,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (selectedDate != null) {
      setState(() {
        dateController.text = "${selectedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.redAccent,
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage('assets/images/pp.png'),
                      backgroundColor: Colors.redAccent,
                    ),
                  ),
                  SizedBox(width: 15),
                  Text(
                    'Hi, $username',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(width: 1),
                ],
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Plan Your Trip',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            SizedBox(height: 10),
            Card(
              color: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    TextField(
                      cursorColor: Colors.black,
                      controller: fromController,
                      decoration: const InputDecoration(
                        prefixIconColor: Colors.redAccent,
                        labelText: 'From',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on_outlined),
                        floatingLabelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      cursorColor: Colors.black,
                      controller: toController,
                      decoration: const InputDecoration(
                        prefixIconColor: Colors.redAccent,
                        labelText: 'To',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.location_on_outlined),
                        floatingLabelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      cursorColor: Colors.black,
                      controller: dateController,
                      decoration: const InputDecoration(
                        prefixIconColor: Colors.redAccent,
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.calendar_today),
                        floatingLabelStyle: TextStyle(color: Colors.black),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.redAccent),
                        ),
                      ),
                      readOnly: true,
                      onTap: () => _selectDate(context),
                    ),
                    SizedBox(height: 10),
                    Center(
                      child: Container(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement search functionality here
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Colors.redAccent,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            'Search',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Roboto',
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            _buildMap(),
            SizedBox(height: 20),
            Text(
              nearestTerminal,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
                fontFamily: 'Roboto',
                color: Colors.redAccent,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Popular Routes',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            Card(
              color: Color.fromARGB(255, 216, 202, 202).withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(Icons.event, color: Colors.redAccent),
                      title: Text('Techiman to Accra'),
                      subtitle: Text('Date: 28th May, 2024'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to trip details
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.event, color: Colors.redAccent),
                      title: Text('Sunyani to Kumasi'),
                      subtitle: Text('Date: 30th May, 2024'),
                      trailing: Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        // Navigate to trip details
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Exclusive Offers',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'Roboto',
              ),
            ),
            Card(
              color: Color.fromARGB(255, 216, 202, 202).withOpacity(0.3),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/images/44.jpg',
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          leading:
                              Icon(Icons.local_offer, color: Colors.redAccent),
                          title: Text('50% off on your first trip!'),
                          subtitle: Text('Use code: FIRST50'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to offer details
                          },
                        ),
                        ListTile(
                          leading:
                              Icon(Icons.local_offer, color: Colors.redAccent),
                          title: Text(
                              '50% off luggage price weighing 2kg and below'),
                          subtitle: Text('Valid till: 31st May, 2024'),
                          trailing: Icon(Icons.arrow_forward_ios),
                          onTap: () {
                            // Navigate to offer details
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return SizedBox(
      height: 200,
      child: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(
              5.6037, -0.1870), // Example coordinates, replace with your own
          zoom: 12,
        ),
        markers: terminals.map((terminal) {
          return Marker(
            markerId: MarkerId(terminal['name']),
            position: LatLng(terminal['latitude'], terminal['longitude']),
            infoWindow: InfoWindow(title: terminal['name']),
          );
        }).toSet(),
      ),
    );
  }
}
