// ignore_for_file: prefer_const_constructors

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/screens/signup_screen.dart';
import 'package:vip_bus_ticketing_system/utils/theme.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5F5),
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
            15, 0, 10, 5), // Adjust internal padding if needed
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align content to the start
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'assets/images/vip_logo_transparent.png',
                width: 250,
                height: 250,
                alignment: Alignment.center,
              ),
            ),
            SizedBox(height: 10),
            Center(
              child: SizedBox(
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIconColor: Colors.redAccent,
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIconColor: Colors.redAccent,
                hintText: '*********',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 350,
                height: 50,
                color: Colors.white,
                child: FilledButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(5.0),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.redAccent),
                  ),
                  child: const Text('Enabled'),
                ),
              ),
            ),
            SizedBox(height: 30),
            Divider(
              height: 24.0,
            ),
            // SizedBox(height: 30),
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account? ',
                style: TextStyle(color: Colors.black),
                children: <TextSpan>[
                  TextSpan(
                    text: 'Sign up',
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.w600),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUpScreen(),
                          ),
                        );
                      },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
  ));
}
