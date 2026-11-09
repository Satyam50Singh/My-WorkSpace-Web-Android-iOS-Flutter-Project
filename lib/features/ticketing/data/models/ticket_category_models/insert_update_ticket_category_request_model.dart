class InsertUpdateTicketCategoryRequestModel {
  final int categoryID;
  final String category;
  final int departmentID;
  final int companyId;
  final String loggedInUserID;
  final String action;

  InsertUpdateTicketCategoryRequestModel({
    required this.categoryID,
    required this.category,
    required this.departmentID,
    required this.companyId,
    required this.loggedInUserID,
    required this.action,
  });

  Map<String, dynamic> toJson() {
    return {
      'Category_ID': categoryID,
      'Category': category,
      'DepartmentID': departmentID,
      'CompanyID': companyId,
      'LoggedInUserID': loggedInUserID,
      'Action': action,
    };
  }
}
