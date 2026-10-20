class InsertUpdateWorkflowRequestModel {
  final int? workflowId;
  final String? workflowName;
  final int? categoryId;
  final int? subCategoryId;
  final String? loggedInUserId;
  final int? companyId;
  final String? action;
  final List<dynamic>? workflowDetails;

  InsertUpdateWorkflowRequestModel({
    this.workflowId,
    this.workflowName,
    this.categoryId,
    this.subCategoryId,
    this.loggedInUserId,
    this.companyId,
    this.action,
    this.workflowDetails,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['WorkflowID'] = workflowId;
    data['Workflow_Name'] = workflowName;
    data['Category_ID'] = categoryId;
    data['SubCategory_ID'] = subCategoryId;
    data['LoggedInUserID'] = loggedInUserId;
    data['CompanyID'] = companyId;
    data['Action'] = action;
    if (workflowDetails != null) {
      data['workflow_details'] = workflowDetails;
    } else {
      data['workflow_details'] = [];
    }
    return data;
  }
}