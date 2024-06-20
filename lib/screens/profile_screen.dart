// ignore_for_file: prefer_const_constructors, dead_code, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/screens/login_screen.dart';
import 'package:vip_bus_ticketing_system/services/authentication.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthMethod _authMethod = AuthMethod();

  // Dummy user data (replace with actual user data)
  String _name = 'John Doe';
  String _email = 'john.doe@example.com';
  String _memberSince = 'January 2020';

  // Controller for editing fields
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  // Focus nodes for text fields
  FocusNode _nameFocus = FocusNode();
  FocusNode _emailFocus = FocusNode();
  FocusNode _phoneNumberFocus = FocusNode();
  FocusNode _addressFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current user data
    _nameController.text = _name;
    _emailController.text = _email;
    // Initialize other controllers with user data if available
  }

  @override
  void dispose() {
    // Dispose controllers and focus nodes to free resources
    _nameController.dispose();
    _emailController.dispose();
    _phoneNumberController.dispose();
    _addressController.dispose();
    _nameFocus.dispose();
    _emailFocus.dispose();
    _phoneNumberFocus.dispose();
    _addressFocus.dispose();
    super.dispose();
  }

  void _updateProfile() {
    // Implement logic to update user profile with new data
    setState(() {
      _name = _nameController.text;
      _email = _emailController.text;
      // Update other profile fields (phone number, address, etc.)
    });
    // Clear focus from text fields
    _nameFocus.unfocus();
    _emailFocus.unfocus();
    _phoneNumberFocus.unfocus();
    _addressFocus.unfocus();
    // Show a message or navigate after profile update
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Profile'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              radius: 50,
              // You can replace the AssetImage with NetworkImage for loading user's profile picture from the internet
              backgroundImage: AssetImage('assets/images/pp.png'),
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _nameController,
              focusNode: _nameFocus,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _emailController,
              focusNode: _emailFocus,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
             TextFormField(
              controller: _phoneNumberController,
              focusNode: _phoneNumberFocus,
              decoration: InputDecoration(
                labelText: 'Phone number',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
             TextFormField(
              controller: _addressController,
              focusNode: _addressFocus,
              decoration: InputDecoration(
                labelText: 'Address',
                border: OutlineInputBorder(),
              ),
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _updateProfile,
              child: Text('Update Profile'),
              style: ElevatedButton.styleFrom(
                primary: Colors.redAccent,
                onPrimary: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
            ),
            SizedBox(height: 20),
            // Text(
            //   'Member Since: $_memberSince',
            //   style: TextStyle(fontSize: 16),
            // ),
            SizedBox(height: 60),

            
            Container(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: _signout,
                child: Text('Logout'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

Future<void> _signout() async {
  await _authMethod.signOut();
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(builder: (context) => LoginScreen()),
  );
}

}

void main() {
  runApp(MaterialApp(
    home: ProfileScreen(),
  ));
}
