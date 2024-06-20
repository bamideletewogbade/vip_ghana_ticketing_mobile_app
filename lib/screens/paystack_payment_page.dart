// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:vip_bus_ticketing_system/models/paystack_config.dart';

class PaymentPage extends StatelessWidget {
  final _emailController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Paystack Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: _amountController,
              decoration: InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _startPayment(context);
              },
              child: Text('Pay Now'),
            ),
          ],
        ),
      ),
    );
  }

  void _startPayment(BuildContext context) async {
    final email = _emailController.text;
    final amount = _amountController.text;

    if (email.isEmpty || amount.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter all details'),
      ));
      return;
    }

    try {
      await PayWithPayStack().now(
        context: context,
        secretKey: ApiKey.secretKey,
        customerEmail: email,
        reference: DateTime.now().microsecondsSinceEpoch.toString(),
        // Removed callbackUrl
        currency: "GHS",
        paymentChannel: ["mobile_money"],
        amount: amount, 
        transactionCompleted: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Transaction Successful'),
          ));
        },
        transactionNotCompleted: () {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Transaction Not Successful'),
          ));
        },
      );
    } catch (e) {
      // Handle any errors that might occur during the payment process
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
      ));
    }
  }
}
