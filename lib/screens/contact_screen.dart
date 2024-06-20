// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class ContactsScreen extends StatefulWidget {
  const ContactsScreen({Key? key}) : super(key: key);

  @override
  _ContactsScreenState createState() => _ContactsScreenState();
}

class _ContactsScreenState extends State<ContactsScreen> {
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _toggleExpand();
  }

  void _toggleExpand() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isExpanded = !_isExpanded;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Colors.redAccent,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        // padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedContainer(
              padding: EdgeInsets.only(top: 10),
              duration: Duration(seconds: 1),
              curve: Curves.fastOutSlowIn,
              height: _isExpanded ? 200 : 100,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/kk.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(0.0),
              ),
            ),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width * 1.0,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'VIP Bus Transport Services',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                          color: Colors.redAccent,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Address:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        '123 VIP Road,\nAccra, Ghana',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Phone Number:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        '+233 123 456 789',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Email:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        'info@vipbustransport.com',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Working Hours:',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      Text(
                        'Monday - Friday: 8 AM - 6 PM\nSaturday: 9 AM - 4 PM\nSunday: Closed',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
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
