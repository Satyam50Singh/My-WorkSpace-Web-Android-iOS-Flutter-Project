import '../../../domain/entities/add_new_request/ticket_sub_category_entity.dart';

class TicketSubCategoryResponseModel {
  int? status;
  String? message;
  TicketSubCategoryModel? ticketSubCategory;

  TicketSubCategoryResponseModel({
    this.status,
    this.message,
    this.ticketSubCategory,
  });

  factory TicketSubCategoryResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketSubCategoryResponseModel(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      ticketSubCategory: TicketSubCategoryModel.fromJson(json),
    );
  }
}

class TicketSubCategoryModel extends TicketSubCategoryEntity {
  const TicketSubCategoryModel({super.subCategories});

  factory TicketSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return TicketSubCategoryModel(
      subCategories: json['SubCategoryDetails'] != null
          ? (json['SubCategoryDetails'] as List)
                .map(
                  (i) => SubCategoryModel.fromJson(i as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }

  TicketSubCategoryEntity toEntity() {
    return TicketSubCategoryEntity(
      subCategories: subCategories,
    );
  }
}

class SubCategoryModel extends SubCategoryEntity {
  const SubCategoryModel({
    super.subCategoryId,
    super.categoryId,
    super.subCategoryDesc,
  });

  factory SubCategoryModel.fromJson(Map<String, dynamic> json) {
    return SubCategoryModel(
      subCategoryId: json['SubCategory_ID'] as int?,
      categoryId: json['Category_ID'] as int?,
      subCategoryDesc: json['SubCategory_Desc'] as String?,
    );
  }
}
