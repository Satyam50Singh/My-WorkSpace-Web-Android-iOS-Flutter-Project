import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/sub_category_master_entity.dart';

class FetchTicketSubCategoryListResponseModel {
  int? status;
  String? message;
  List<SubCategoryModel>? subCategoryList;

  FetchTicketSubCategoryListResponseModel({
    this.status,
    this.message,
    this.subCategoryList,
  });

  factory FetchTicketSubCategoryListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FetchTicketSubCategoryListResponseModel(
      status: json['Status'] as int? ?? 0,
      message: json['Message'] as String? ?? "",
      subCategoryList: json['subcategory'] != null
          ? (json['subcategory'] as List)
                .map(
                  (i) => SubCategoryModel.fromJson(i as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }
}

class SubCategoryModel extends SubCategoryMasterEntity {
  SubCategoryModel(
    super.categoryID,
    super.category,
    super.subCategoryID,
    super.subCategory,
    super.priority,
  );

  SubCategoryModel.fromJson(Map<String, dynamic> json)
    : super(
        json['Category_ID'] as int?,
        json['Category'] as String?,
        json['SubCategory_ID'] as int?,
        json['SubCategory'] as String?,
        json['Priority'] as String?,
      );

  SubCategoryMasterEntity toEntity() {
    return SubCategoryMasterEntity(
      subCategoryID,
      subCategory,
      categoryID,
      category,
      priority,
    );
  }
}
