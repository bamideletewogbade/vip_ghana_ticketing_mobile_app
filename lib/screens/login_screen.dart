// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_build_context_synchronously, prefer_const_constructors_in_immutables, curly_braces_in_flow_control_structures

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:vip_bus_ticketing_system/screens/home_screen.dart';
import 'package:vip_bus_ticketing_system/screens/admin_home_screen.dart'; 
import 'package:vip_bus_ticketing_system/screens/signup_screen.dart';
import '../services/authentication.dart';
import '../widgets/snackbar.dart';

void main() {
  runApp(MaterialApp(
    home: LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class LoginScreen extends StatefulWidget {
  LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  final AuthMethod _authMethod = AuthMethod();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    setState(() {
      isLoading = true;
    });

    String email = emailController.text.trim().toLowerCase();

    setState(() {
      isLoading = false;
    });

    if (email.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
              var loginResult = await _authMethod.loginUser(
              email: email,
              password: passwordController.text,
            );
          if (loginResult == "success") {
            if(emailController.text.startsWith('admin'))
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => AdminHomeScreen()), 
            );
          } else {
            // showSnackBar(context, loginResult);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomeScreen()), 
            ); 
          }
        } catch (e) {
        showSnackBar(context, "An error occurred. Please try again."); 
      }
    } else {
      showSnackBar(context, "Please enter email and password.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(15, 0, 10, 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 50, 40, 10),
              child: Center(
                child: Image.asset(
                  'assets/images/vip_logo_transparent.png',
                  width: 250,
                  height: 250,
                  alignment: Alignment.center,
                ),
              ),
            ),
            SizedBox(height: 5),
            Center(
              child: SizedBox(
                child: TextField(
                  cursorColor: Colors.black,
                  controller: emailController,
                  decoration: const InputDecoration(
                    prefixIconColor: Colors.redAccent,
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.email_outlined),
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
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: passwordController,
              cursorColor: Colors.black,
              decoration: const InputDecoration(
                labelText: 'Password',
                prefixIconColor: Colors.redAccent,
                hintText: '*********',
                hintStyle: TextStyle(color: Colors.grey),
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outline),
                floatingLabelStyle: TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  borderSide: BorderSide(color: Colors.redAccent),
                ),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Center(
              child: SizedBox(
                width: 350,
                height: 50,
                child: ElevatedButton(
                  onPressed: _login,
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(5.0),
                    backgroundColor:
                        MaterialStateProperty.all(Colors.redAccent),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Login',
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
            SizedBox(height: 15),
            Divider(
              height: 24.0,
              thickness: 0.4,
              color: Colors.black,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Add social login buttons here if needed
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
              child: RichText(
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
                              builder: (context) => SignupScreen(),
                            ),
                          );
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
}
