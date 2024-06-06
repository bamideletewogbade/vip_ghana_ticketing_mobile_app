class Ticket {
  Ticket(
      {this.ticketNumber,
      this.destination,
      this.date,
      this.time,
      this.price,
      this.status});
  String? ticketNumber;
  String? destination;
  String? date;
  String? time;
  int? price;
  TicketStatus? status;
}

class TicketStatus {
  static const confirmed = 0;
  static const pending = 1;
  static const cancelled = 2;
}
