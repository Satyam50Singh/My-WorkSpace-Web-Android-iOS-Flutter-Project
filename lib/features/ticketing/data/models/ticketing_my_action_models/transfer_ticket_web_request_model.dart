class TransferTicketWebRequestModel {
  final int? ticketId;
  final String? remarks;
  final String? empCD;
  final int? transferToUserId;
  final int? companyId;
  final String? platformType;

  TransferTicketWebRequestModel({
    required this.ticketId,
    required this.remarks,
    required this.empCD,
    required this.transferToUserId,
    required this.companyId,
    required this.platformType,
  });

  @override
  String toString() {
    return 'TransferTicketWebRequestModel(ticketId: $ticketId, remarks: $remarks, empCD: $empCD, transferToUserId: $transferToUserId, companyId: $companyId, platformType: $platformType)';
  }

  Map<String, dynamic> toJson() {
    return {
      'TicketID': ticketId,
      'Remarks': remarks,
      'EmpCD': empCD,
      'TransferToUserId': transferToUserId,
      'CompanyID': companyId,
      'Platform_Type': platformType,
    };
  }
}
