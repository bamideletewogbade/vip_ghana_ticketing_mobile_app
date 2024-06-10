import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:vip_bus_ticketing_system/screens/search_result_screen.dart';
import 'package:vip_bus_ticketing_system/screens/tickets_screen.dart';
import 'package:vip_bus_ticketing_system/screens/profile_screen.dart';
import 'package:vip_bus_ticketing_system/screens/support_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vip_bus_ticketing_system/services/bus_service.dart';

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
        backgroundColor: Colors.redAccent,
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
  final BusService _busService = BusService();
  String username = "";

  final TextEditingController dateController = TextEditingController();
  String nearestTerminal = '';
  GoogleMapController? _mapController;

  String selectedFrom = '';
  String selectedTo = '';
  String selectedSession = '';

  List<String> locations = [
    'Accra Terminal',
    'Kumasi Terminal',
    'Sunyani Terminal'
  ];
  List<String> sessions = [
    'Morning session (5am - 8am)',
    'Evening session (4pm - 7pm)'
  ];

  Future<void> fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      setState(() {
        username = userDoc['name'];
      });
    }
  }

  // List of VIP bus terminals (example data)
  final List<Map<String, dynamic>> terminals = [
    {'name': 'Accra Terminal', 'latitude': 5.6037, 'longitude': -0.1870},
    {'name': 'Kumasi Terminal', 'latitude': 6.6884, 'longitude': -1.6244},
    {'name': 'Sunyani Terminal', 'latitude': 7.3390, 'longitude': -2.3267},
  ];

  @override
  void initState() {
    super.initState();
    fetchUserName();
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/images/pp.png'),
                  backgroundColor: Colors.redAccent,
                ),
                SizedBox(width: 15),
                Text(
                  'Hi,',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Roboto',
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  username,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                  ),
                ),
              ],
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
                    DropdownButtonFormField<String>(
                      value: selectedFrom.isEmpty ? null : selectedFrom,
                      hint: Text('Select From'),
                      items: locations.map((location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedFrom = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_on_outlined,
                            color: Colors.redAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
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
                    DropdownButtonFormField<String>(
                      value: selectedTo.isEmpty ? null : selectedTo,
                      hint: Text('Select To'),
                      items: locations.map((location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTo = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_on_outlined,
                            color: Colors.redAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
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
                    DropdownButtonFormField<String>(
                      value: selectedSession.isEmpty ? null : selectedSession,
                      hint: Text('Select Session'),
                      items: sessions.map((session) {
                        return DropdownMenuItem<String>(
                          value: session,
                          child: Text(session),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedSession = value!;
                        });
                      },
                      decoration: const InputDecoration(
                        prefixIcon:
                            Icon(Icons.calendar_today, color: Colors.redAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
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
                    Center(
                      child: Container(
                        width: 300,
                        child: ElevatedButton(
                          onPressed: () {
                            // Implement search functionality here
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchResultsScreen(
                                  from: selectedFrom,
                                  to: selectedTo,
                                  session: selectedSession,
                                ),
                              ),
                            );
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
            _buildMap(),
            SizedBox(height: 20),
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
              color: Colors.blueGrey.withOpacity(0.3),
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
