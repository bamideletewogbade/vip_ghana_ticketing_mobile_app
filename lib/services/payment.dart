// import 'package:hubtel_payment_flutter/hubtel_payment_flutter.dart';

// void makePayment() async {
//   try {
//     var response = await HubtelPaymentFlutter.checkout(
//       clientID: 'YOUR_CLIENT_ID',
//       secretKey: 'YOUR_SECRET_KEY',
//       recipient: 'RECIPIENT_PHONE_NUMBER',
//       amount: 100.0,
//       channel: Channel.card,
//       billingEmail: 'customer@example.com',
//       description: 'Payment for bus ticket',
//     );

//     if (response.isSuccessful) {
//       // Payment was successful
//       print('Payment successful');
//     } else {
//       // Payment failed
//       print('Payment failed: ${response.error}');
//     }
//   } catch (e) {
//     // An error occurred
//     print('Error: $e');
//   }
// }
