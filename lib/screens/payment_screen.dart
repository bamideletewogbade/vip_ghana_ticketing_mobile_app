import 'package:flutter/material.dart';
import 'package:pay_with_paystack/pay_with_paystack.dart';
import 'package:vip_bus_ticketing_system/models/paystack_config.dart';

class PaymentScreen extends StatefulWidget {
  final double totalPrice;

  const PaymentScreen({Key? key, required this.totalPrice}) : super(key: key);

  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  String mobileNumber = '';

  void _makePayment(String mobileNumber) async {
    try {
      print("Initiating payment with mobile number: $mobileNumber");
      await PayWithPayStack().now(
        context: context,
        secretKey: ApiKey.secretKey,
        customerEmail: mobileNumber,
        reference: DateTime.now().microsecondsSinceEpoch.toString(),
        currency: "GHS",
        paymentChannel: ["mobile_money"],
        amount: (widget.totalPrice * 100).toString(),
        transactionCompleted: () {
          print("Transaction completed successfully.");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Transaction Successful'),
          ));
          Navigator.of(context).pop();
        },
        transactionNotCompleted: () {
          print("Transaction not completed.");
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Transaction Not Successful'),
          ));
        },
      );
    } catch (e) {
      print("Error occurred during payment: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('An error occurred: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Enter Mobile Number'),
              onChanged: (value) {
                mobileNumber = value;
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.redAccent),
              ),
              onPressed: () {
                _makePayment(mobileNumber);
              },
              child: Text('Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}
