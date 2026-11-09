class TransferToOtherWorkflowRequestBody {
  final int? ticketId;
  final int? categoryId;
  final int? subCategoryId;
  final String? transferReason;
  final String? empCD;
  final int? companyId;
  final String? platformType;

  TransferToOtherWorkflowRequestBody({
    required this.ticketId,
    required this.categoryId,
    required this.subCategoryId,
    required this.transferReason,
    required this.empCD,
    required this.companyId,
    required this.platformType,
  });

  Map<String, dynamic> toJson() {
    return {
      'TicketID': ticketId,
      'CategoryID': categoryId,
      'SubCategoryID': subCategoryId,
      'Transfer_Reason': transferReason,
      'EmpCD': empCD,
      'CompanyID': companyId,
      'Platform_Type': platformType,
    };
  }
}
