class AcceptWebTicketRequestModel {
  final String? empCD;
  final int? companyId;
  final String? platformType;
  final String? ticketId;
  final bool? isAcceptedByAnotherUser;

  AcceptWebTicketRequestModel({
    required this.empCD,
    required this.companyId,
    required this.platformType,
    required this.ticketId,
    required this.isAcceptedByAnotherUser,
  });

  @override
  String toString() {
    return 'AcceptWebTicketRequestModel(empCD: $empCD, companyId: $companyId, platformType: $platformType, ticketId: $ticketId, isAcceptedByAnotherUser: $isAcceptedByAnotherUser)';
  }

  Map<String, Object?> toJson() {
    return {
      'EmpCD': empCD,
      'CompanyID': companyId,
      'Platform_Type': platformType,
      'TicketID': ticketId,
      'Is_AcceptedByAnotherUser': isAcceptedByAnotherUser == true ? 1 : 0,
    };
  }
}
