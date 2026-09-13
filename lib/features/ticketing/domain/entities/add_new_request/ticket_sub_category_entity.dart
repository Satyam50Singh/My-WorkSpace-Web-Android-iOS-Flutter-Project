class TicketSubCategoryEntity {
  final List<SubCategoryEntity>? subCategories;

  const TicketSubCategoryEntity({this.subCategories});
}

class SubCategoryEntity {
  final int? subCategoryId;
  final int? categoryId;
  final String? subCategoryDesc;

  const SubCategoryEntity({
    this.subCategoryId,
    this.categoryId,
    this.subCategoryDesc,
  });
}
