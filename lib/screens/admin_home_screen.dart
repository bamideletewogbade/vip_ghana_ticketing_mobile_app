// ignore_for_file: prefer_const_constructors, prefer_final_fields

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vip_bus_ticketing_system/screens/admin_bus_mgt_screen.dart';
import 'package:vip_bus_ticketing_system/screens/admin_ticket_mgt_screen.dart';
import 'package:vip_bus_ticketing_system/screens/admin_user_mgt_screen.dart';
import 'package:vip_bus_ticketing_system/screens/contact_screen.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MaterialApp(
    home: AdminHomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    AdminHomeContent(),
    AdminUsersMgtScreen(),
    AdminTicketManagementScreen(),
    AdminBusManagementScreen(),
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
            'Dashboard',
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
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.airplane_ticket_outlined),
            label: 'Tickets',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.directions_bus_filled),
            label: 'Buses',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

class AdminHomeContent extends StatefulWidget {
  const AdminHomeContent({super.key});

  @override
  State<AdminHomeContent> createState() => _AdminHomeContentState();
}

class _AdminHomeContentState extends State<AdminHomeContent> {
  int totalUsers = 0;
  int totalTickets = 0;
  double totalRevenue = 0.0;
  int totalBuses = 0;
  int newUsersThisMonth = 0;
  double monthlyRevenue = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchAnalyticsData();
  }

  Future<void> _fetchAnalyticsData() async {
    try {
      // Fetch total users
      QuerySnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        totalUsers = userSnapshot.size;
      });

      // Fetch total tickets
      QuerySnapshot ticketSnapshot =
          await FirebaseFirestore.instance.collection('tickets').get();
      setState(() {
        totalTickets = ticketSnapshot.size;
      });

      // Calculate total revenue
      double revenue = 0.0;
      double monthlyRevenueTemp = 0.0;
      for (var doc in ticketSnapshot.docs) {
        revenue += doc['price'];
        
        // Parse the date string to DateTime object
        DateTime date = DateTime.parse(doc['date']);
        
        if (date.month == DateTime.now().month) {
          monthlyRevenueTemp += doc['price'];
        }
      }
      setState(() {
        totalRevenue = revenue;
        monthlyRevenue = monthlyRevenueTemp;
      });

      // Fetch total buses
      QuerySnapshot busSnapshot =
          await FirebaseFirestore.instance.collection('buses').get();
      setState(() {
        totalBuses = busSnapshot.size;
      });

      // Calculate new users this month
      int newUsersTemp = 0;
      for (var doc in userSnapshot.docs) {
        if ((doc['createdAt'] as Timestamp).toDate().month == DateTime.now().month) {
          newUsersTemp++;
        }
      }
      setState(() {
        newUsersThisMonth = newUsersTemp;
      });
    } catch (e) {
      print("Error fetching analytics data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Analytics',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildAnalyticsCard('Total Users', totalUsers.toString(), Icons.people, Colors.blue),
                _buildAnalyticsCard('Total Tickets', totalTickets.toString(), Icons.airplane_ticket, Colors.green),
                _buildAnalyticsCard(
                    'Total Revenue', 'GHS ${totalRevenue.toStringAsFixed(2)}', Icons.attach_money, Colors.red),
                _buildAnalyticsCard('Total Buses', totalBuses.toString(), Icons.directions_bus, Colors.orange),
                _buildAnalyticsCard('New Users (This Month)', newUsersThisMonth.toString(), Icons.new_releases, Colors.purple),
                _buildAnalyticsCard(
                    'Monthly Revenue', 'GHS ${monthlyRevenue.toStringAsFixed(2)}', Icons.trending_up, Colors.teal),
              ],
            ),
            SizedBox(height: 16),
            _buildLineChart(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsCard(String title, String value, IconData icon, Color color) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                value,
                style: TextStyle(
                  fontSize: 24,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Monthly Revenue Trend',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: [
                        FlSpot(1, 100),
                        FlSpot(2, 200),
                        FlSpot(3, 150),
                        FlSpot(4, 300),
                        FlSpot(5, 250),
                        FlSpot(6, 350),
                        FlSpot(7, 300),
                        FlSpot(8, 400),
                        FlSpot(9, 350),
                        FlSpot(10, 450),
                        FlSpot(11, 400),
                        FlSpot(12, 500),
                      ],
                      isCurved: true,
                      barWidth: 4,
                      colors: [Colors.redAccent],
                      belowBarData: BarAreaData(
                        show: true,
                        colors: [Colors.redAccent.withOpacity(0.3)],
                      ),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(showTitles: true),
                    bottomTitles: SideTitles(showTitles: true),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
