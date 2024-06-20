class Transaction {
  String email;
  int amount; // Amount in kobo
  String reference;
  String currency;

  Transaction({
    required this.email,
    required this.amount,
    required this.reference,
    required this.currency,
  });

  // Convert a Transaction instance to a map for JSON encoding
  Map<String, dynamic> toJSON() {
    return {
      'email': email,
      'amount': amount,
      'reference': reference,
      'currency': currency,
    };
  }

  // Create a Transaction instance from a map (JSON decoding)
  factory Transaction.fromJSON(Map<String, dynamic> json) {
    return Transaction(
      email: json['email'],
      amount: json['amount'],
      reference: json['reference'],
      currency: json['currency'],
    );
  }
}

// void main() {
//   // Example usage:

//   // Creating a Transaction instance
//   Transaction transaction = Transaction(
//     email: 'customer@example.com',
//     amount: 5000,
//     reference: 'ChargedFrom_1234567890',
//     currency: 'NGN',
//   );

//   // Convert Transaction to JSON
//   Map<String, dynamic> json = transaction.toJSON();
//   print('Transaction to JSON: $json');

//   // Convert JSON to Transaction
//   Transaction newTransaction = Transaction.fromJSON(json);
//   print('Transaction from JSON: ${newTransaction.email}, ${newTransaction.amount}, ${newTransaction.reference}, ${newTransaction.currency}');
// }
