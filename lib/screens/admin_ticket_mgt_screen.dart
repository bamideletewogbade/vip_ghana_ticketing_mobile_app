// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminTicketManagementScreen extends StatefulWidget {
  const AdminTicketManagementScreen({super.key});

  @override
  _AdminTicketManagementScreenState createState() => _AdminTicketManagementScreenState();
}

class _AdminTicketManagementScreenState extends State<AdminTicketManagementScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  late String ticketId;
  late double price;
  late DateTime date;

  void _showAddTicketDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Ticket'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Ticket ID'),
                  onSaved: (value) => ticketId = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter ticket ID' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => price = double.parse(value!),
                  validator: (value) => value!.isEmpty ? 'Please enter price' : null,
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                  onSaved: (value) => date = DateTime.parse(value!),
                  validator: (value) => value!.isEmpty ? 'Please enter date' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _firestore.collection('tickets').add({
                    'id': ticketId,
                    'price': price,
                    'date': date,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showEditTicketDialog(DocumentSnapshot ticket) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Ticket'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  initialValue: ticket['id'],
                  decoration: InputDecoration(labelText: 'Ticket ID'),
                  onSaved: (value) => ticketId = value!,
                  validator: (value) => value!.isEmpty ? 'Please enter ticket ID' : null,
                ),
                TextFormField(
                  initialValue: ticket['price'].toString(),
                  decoration: InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => price = double.parse(value!),
                  validator: (value) => value!.isEmpty ? 'Please enter price' : null,
                ),
                TextFormField(
                  initialValue: (ticket['date'] as Timestamp).toDate().toString().split(' ')[0],
                  decoration: InputDecoration(labelText: 'Date (YYYY-MM-DD)'),
                  onSaved: (value) => date = DateTime.parse(value!),
                  validator: (value) => value!.isEmpty ? 'Please enter date' : null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  ticket.reference.update({
                    'id': ticketId,
                    'price': price,
                    'date': date,
                  });
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ticket Management', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('tickets').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var ticket = snapshot.data!.docs[index];
              return TicketCard(
                ticket: ticket,
                onEdit: () => _showEditTicketDialog(ticket),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add),
        onPressed: _showAddTicketDialog,
      ),
    );
  }
}

class TicketCard extends StatelessWidget {
  final DocumentSnapshot ticket;
  final VoidCallback onEdit;

  const TicketCard({
    required this.ticket,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Ticket ID: ${ticket['id']}', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Price: ${ticket['price']}'),
            SizedBox(height: 10),
            Text('Date: ${(ticket['date'] as Timestamp).toDate()}'),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: onEdit,
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await ticket.reference.delete();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
