class AddNewTicketRequestEntity {
  final List<TicketDetailsEntity>? ticketDetailsList;

  AddNewTicketRequestEntity(this.ticketDetailsList);
}

class TicketDetailsEntity {
  final int? ticketId;
  final String? ticketNo;

  TicketDetailsEntity(this.ticketId, this.ticketNo);
}
