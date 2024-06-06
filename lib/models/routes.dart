class Trips {
  Trips(
      this.tripId,
      this.tripName,
      this.departure,
      this.arrival,
      this.departureTime,
      this.arrivalTime,
      this.busNumber,
      this.availableBus,
      this.passengerCount);

  String? tripId;
  String? tripName;
  String? departure;
  String? arrival;
  String? departureTime;
  String? arrivalTime;
  String? busNumber;
  int? availableBus;
  int? passengerCount;

  factory Trips.fromJson(Map<String, dynamic> json) => Trips(
        json["tripId"],
        json["tripName"],
        json["departure"],
        json["arrival"],
        json["departureTime"],
        json["arrivalTime"],
        json["busNumber"],
        json["availableBus"],
        json["passengerCount"],
      );
}
