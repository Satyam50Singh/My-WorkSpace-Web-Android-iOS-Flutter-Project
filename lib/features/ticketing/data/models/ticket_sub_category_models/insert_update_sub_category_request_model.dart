class InsertUpdateSubCategoryRequestModel {
  final int categoryID;
  final int subCategoryID;
  final String subCategory;
  final int companyID;
  final String loggedInUserID;
  final String action;
  final String priority;

  InsertUpdateSubCategoryRequestModel({
    required this.categoryID,
    required this.subCategoryID,
    required this.subCategory,
    required this.companyID,
    required this.loggedInUserID,
    required this.action,
    required this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'Category_ID': categoryID,
      'SubCategory_ID': subCategoryID,
      'SubCategory': subCategory,
      'CompanyID': companyID,
      'LoggedInUserID': loggedInUserID,
      'Action': action,
      'Priority': priority,
    };
  }
}
