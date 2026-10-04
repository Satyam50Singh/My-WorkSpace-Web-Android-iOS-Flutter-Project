class TransferTicketWebRequestModel {
  final int? ticketId;
  final String? remarks;
  final String? empCD;
  final int? transferToUserId;
  final int? companyID;
  final String? platformType;

  TransferTicketWebRequestModel({
    required this.ticketId,
    required this.remarks,
    required this.empCD,
    required this.transferToUserId,
    required this.companyID,
    required this.platformType,
  });

  String toString() {
    return 'TransferTicketWebRequestModel(ticketId: $ticketId, remarks: $remarks, empCD: $empCD, transferToUserId: $transferToUserId, companyID: $companyID, platformType: $platformType)';
  }
}
