// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'User Management',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}