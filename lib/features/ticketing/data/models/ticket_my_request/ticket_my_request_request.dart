class TicketMyRequestRequest {
  final int? companyId;
  final String? empCd;
  final String? fromDate;
  final String? toDate;
  final int? pageSize;
  final int? pageCount;
  final String? actionStatus;
  final String? searchText;
  final int? departmentId;
  final int? categoryId;
  final String? ticketType;

TicketMyRequestRequest({
    this.companyId,
    this.empCd,
    this.fromDate,
    this.toDate,
    this.pageSize,
    this.pageCount,
    this.actionStatus,
    this.searchText,
    this.departmentId,
    this.categoryId,
    this.ticketType,
  });

  Map<String, dynamic> toJson() {
    return {
      'CompanyID': companyId,
      'EmpCD': empCd,
      'FromDate': fromDate,
      'ToDate': toDate,
      'PageSize': pageSize,
      'PageCount': pageCount,
      'ActionStatus': actionStatus,
      'SearchText': searchText,
      'DepartmentId': departmentId,
      'CategoryId': categoryId,
      'TicketType': ticketType,
    };
  }
}