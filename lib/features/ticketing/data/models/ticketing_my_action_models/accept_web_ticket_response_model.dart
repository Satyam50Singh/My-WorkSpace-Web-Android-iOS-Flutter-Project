class AcceptWebTicketResponseModel {
  int? status;
  String? message;

  AcceptWebTicketResponseModel({this.status, this.message});

  factory AcceptWebTicketResponseModel.fromJson(Map<String, dynamic> json) {
    return AcceptWebTicketResponseModel(
      status: json['Status'] as int? ?? 0,
      message: json['Message'] as String? ?? "",
    );
  }
}
