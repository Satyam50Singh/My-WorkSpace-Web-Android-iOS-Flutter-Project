class AcceptWebTicketRequestModel {
  final String? empCD;
  final int? companyID;
  final String? platformType;
  final String? ticketId;
  final bool? isAcceptedByAnotherUser;

  AcceptWebTicketRequestModel({
    required this.empCD,
    required this.companyID,
    required this.platformType,
    required this.ticketId,
    required this.isAcceptedByAnotherUser,
  });

  @override
  String toString() {
    return 'AcceptWebTicketRequestModel(empCD: $empCD, companyID: $companyID, platformType: $platformType, ticketId: $ticketId, isAcceptedByAnotherUser: $isAcceptedByAnotherUser)';
  }

  Map<String, Object?> toJson() {
    return {
      'EmpCD': empCD,
      'CompanyID': companyID,
      'Platform_Type': platformType,
      'TicketID': ticketId,
      'Is_AcceptedByAnotherUser': isAcceptedByAnotherUser == true ? 1 : 0,
    };
  }
}
