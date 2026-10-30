class FetchTicketReportWebRequestModel {
  final int? companyID;
  final String? fromDate;
  final String? toDate;
  final int? pageSize;
  final int? pageCount;
  final String? actionStatus;
  final String? searchText;
  final int? departmentId;
  final int? categoryId;
  final int? subCategoryId;
  final int? locationId;
  final String? ticketType;

  FetchTicketReportWebRequestModel({
    this.companyID,
    this.fromDate = "09-10-2026",
    this.toDate = "30-10-2026",
    this.pageSize = 10,
    this.pageCount = 1,
    this.actionStatus,
    this.searchText,
    this.departmentId = 0,
    this.categoryId = 0,
    this.subCategoryId = 0,
    this.locationId = 0,
    this.ticketType = "All",
  });
}
