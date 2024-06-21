// ignore_for_file: prefer_const_constructors, prefer_final_fields, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vip_bus_ticketing_system/screens/admin_home_screen.dart';

void main() {
  runApp(MaterialApp(
    home: AdminHomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class AdminBusManagementScreen extends StatefulWidget {
  @override
  _AdminBusManagementScreenState createState() => _AdminBusManagementScreenState();
}

class _AdminBusManagementScreenState extends State<AdminBusManagementScreen> {
  TextEditingController _busNameController = TextEditingController();
  TextEditingController _busNumberController = TextEditingController();
  TextEditingController _busRouteController = TextEditingController();

  @override
  void dispose() {
    _busNameController.dispose();
    _busNumberController.dispose();
    _busRouteController.dispose();
    super.dispose();
  }

  Future<void> _addBus() async {
    try {
      await FirebaseFirestore.instance.collection('buses').add({
        'name': _busNameController.text,
        'number': _busNumberController.text,
        'route': _busRouteController.text,
        'createdAt': Timestamp.now(),
      });
      _busNameController.clear();
      _busNumberController.clear();
      _busRouteController.clear();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bus added successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to add bus: $e')));
    }
  }

  Future<void> _deleteBus(String id) async {
    try {
      await FirebaseFirestore.instance.collection('buses').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bus deleted successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete bus: $e')));
    }
  }

  Future<void> _updateBus(String id, String name, String number, String route) async {
    try {
      await FirebaseFirestore.instance.collection('buses').doc(id).update({
        'name': name,
        'number': number,
        'route': route,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Bus updated successfully')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update bus: $e')));
    }
  }

  Future<void> _showUpdateDialog(String id, String currentName, String currentNumber, String currentRoute) async {
    _busNameController.text = currentName;
    _busNumberController.text = currentNumber;
    _busRouteController.text = currentRoute;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Update Bus'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _busNameController,
                decoration: InputDecoration(labelText: 'Bus Name'),
              ),
              TextField(
                controller: _busNumberController,
                decoration: InputDecoration(labelText: 'Bus Number'),
              ),
              TextField(
                controller: _busRouteController,
                decoration: InputDecoration(labelText: 'Bus Route'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _updateBus(id, _busNameController.text, _busNumberController.text, _busRouteController.text);
                Navigator.of(context).pop();
              },
              child: Text('Update'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBusList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('buses').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        var buses = snapshot.data?.docs;
        if (buses == null || buses.isEmpty) {
          return Center(child: Text('No buses found'));
        }

        return ListView.builder(
          itemCount: buses.length,
          itemBuilder: (context, index) {
            var bus = buses[index];

            return Card(
              elevation: 4,
              child: ListTile(
                title: Text(bus['name']),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Number: ${bus['number']}'),
                    Text('Route: ${bus['route']}'),
                  ],
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _showUpdateDialog(bus.id, bus['name'], bus['number'], bus['route']),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteBus(bus.id),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Bus Management',
            style: TextStyle(
              color: Colors.white,
              fontFamily: 'Roboto',
            ),
          ),
        ),
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: _buildBusList(),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showAddBusDialog(),
              child: Text('Add Bus'),
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAddBusDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add Bus'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _busNameController,
                decoration: InputDecoration(labelText: 'Bus Name'),
              ),
              TextField(
                controller: _busNumberController,
                decoration: InputDecoration(labelText: 'Bus Number'),
              ),
              TextField(
                controller: _busRouteController,
                decoration: InputDecoration(labelText: 'Bus Route'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addBus();
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
