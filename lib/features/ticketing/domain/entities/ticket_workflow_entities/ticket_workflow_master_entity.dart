class TicketWorkflowMasterEntity {
  final int? workflowID;
  final String? workflowName;
  final int? categoryID;
  final String? category;
  final int? subCategoryID;
  final String? subCategory;
  final int? noOfLevels;

  TicketWorkflowMasterEntity(
    this.workflowID,
    this.workflowName,
    this.categoryID,
    this.category,
    this.subCategoryID,
    this.subCategory,
    this.noOfLevels,
  );
}
