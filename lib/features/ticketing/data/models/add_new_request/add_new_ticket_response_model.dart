import '../../../domain/entities/add_new_request/add_new_ticket_request_entity.dart';

class AddNewTicketResponseModel {
  final int? status;
  final String? message;
  final AddNewTicketModel? addNewTicketModel;

  AddNewTicketResponseModel(
    this.status,
    this.message,
    this.addNewTicketModel,
  );

  factory AddNewTicketResponseModel.fromJson(Map<String, dynamic> json) {
    return AddNewTicketResponseModel(
      json['Status'] as int?,
      json['Message'] as String?,
      AddNewTicketModel.fromJson(json),
    );
  }
}

class AddNewTicketModel extends AddNewTicketRequestEntity {
  AddNewTicketModel(super.ticketDetailsList);

  factory AddNewTicketModel.fromJson(Map<String, dynamic> json) {
    return AddNewTicketModel(
      json['TicketDetails'] != null
          ? (json['TicketDetails'] as List)
                .map(
                  (i) => TicketDetailsModel.fromJson(i as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }

  AddNewTicketRequestEntity toEntity() {
    return AddNewTicketRequestEntity(ticketDetailsList);
  }
}

class TicketDetailsModel extends TicketDetailsEntity {
  TicketDetailsModel(super.ticketId, super.ticketNo);

  factory TicketDetailsModel.fromJson(Map<String, dynamic> json) {
    return TicketDetailsModel(
      json['TicketID'] as int?,
      json['TicketNo'] as String?,
    );
  }
}
