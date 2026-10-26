class SubCategoryMasterEntity {
  final int? subCategoryID;
  final String? subCategory;
  final int? categoryID;
  final String? category;
  final String? priority;

  SubCategoryMasterEntity({
    this.subCategoryID,
    this.subCategory,
    this.categoryID,
    this.category,
    this.priority,
  });

  Map<String, dynamic> toJson() {
    return {
      'subCategoryID': subCategoryID,
      'subCategory': subCategory,
      'categoryID': categoryID,
      'category': category,
      'priority': priority,
    };
  }
}
