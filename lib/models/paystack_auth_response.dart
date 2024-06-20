class PaystackAuthResponse {
  String reference;
  String accessCode;
  String authorizationUrl;

  PaystackAuthResponse({
    required this.reference,
    required this.accessCode,
    required this.authorizationUrl,
  });

  // Convert a PaystackAuthResponse instance to a map for JSON encoding
  Map<String, dynamic> toJSON() {
    return {
      'reference': reference,
      'access_code': accessCode,
      'authorization_url': authorizationUrl,
    };
  }

  // Create a PaystackAuthResponse instance from a map (JSON decoding)
  factory PaystackAuthResponse.fromJSON(Map<String, dynamic> json) {
    return PaystackAuthResponse(
      reference: json['reference'],
      accessCode: json['access_code'],
      authorizationUrl: json['authorization_url'],
    );
  }
}
