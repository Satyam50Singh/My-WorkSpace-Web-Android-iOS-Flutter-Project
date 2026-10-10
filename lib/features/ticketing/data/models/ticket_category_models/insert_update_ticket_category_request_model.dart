class InsertUpdateTicketCategoryRequestModel {
  final int categoryID;
  final String category;
  final int departmentID;
  final int companyID;
  final String loggedInUserID;
  final String action;

  InsertUpdateTicketCategoryRequestModel({
    required this.categoryID,
    required this.category,
    required this.departmentID,
    required this.companyID,
    required this.loggedInUserID,
    required this.action,
  });

  Map<String, dynamic> toJson() {
    return {
      'Category_ID': categoryID,
      'Category': category,
      'DepartmentID': departmentID,
      'CompanyID': companyID,
      'LoggedInUserID': loggedInUserID,
      'Action': action,
    };
  }
}
