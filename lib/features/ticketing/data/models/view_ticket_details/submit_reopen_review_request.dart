class SubmitReopenReviewRequest {
  final int? companyId;
  final String? empCd;
  final String? ticketId;
  final String? remarks;
  final int? isReview;

  SubmitReopenReviewRequest({
    required this.companyId,
    required this.empCd,
    required this.ticketId,
    required this.remarks,
    required this.isReview,
  });

  // to json func
  Map<String, dynamic> toJson() {
    return {
      'CompanyID': companyId,
      'EmpCD': empCd,
      'TicketID': ticketId,
      'Remarks': remarks,
      'Is_Review': isReview,
    };
  }
}