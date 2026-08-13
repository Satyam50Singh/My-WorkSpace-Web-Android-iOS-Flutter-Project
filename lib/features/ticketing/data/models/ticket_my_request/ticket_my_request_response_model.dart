
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_my_request/ticket_detail_model.dart';

class TicketMyRequestResponseModel {
  int? status;
  String? message;
  TicketDetailModel? ticketDetail;

  TicketMyRequestResponseModel({
    this.status,
    this.message,
    this.ticketDetail,
  });

  factory TicketMyRequestResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketMyRequestResponseModel(
      status: json['Status'] as int? ?? 0,
      message: json['Message'] as String? ?? "",
      // We pass the entire json because TotalRecords, TotalPages etc. are at the root
      ticketDetail: TicketDetailModel.fromJson(json),
    );
  }
}
