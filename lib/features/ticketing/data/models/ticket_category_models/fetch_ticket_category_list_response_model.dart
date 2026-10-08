import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/ticket_category_entity.dart';

class FetchTicketCategoryListResponseModel {
  int? status;
  String? message;
  List<CategoryModel>? categoryList;

  FetchTicketCategoryListResponseModel({
    this.status,
    this.message,
    this.categoryList,
  });

  factory FetchTicketCategoryListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FetchTicketCategoryListResponseModel(
      status: json['Status'] as int? ?? 0,
      message: json['Message'] as String? ?? "",
      categoryList: json['category'] != null
          ? (json['category'] as List)
                .map((i) => CategoryModel.fromJson(i as Map<String, dynamic>))
                .toList()
          : null,
    );
  }
}

class CategoryModel extends TicketCategoryEntity {
  CategoryModel(
    super.categoryID,
    super.category,
    super.departmentID,
    super.department,
  );

  CategoryModel.fromJson(Map<String, dynamic> json)
    : super(
        json['Category_ID'] as int?,
        json['Category'] as String?,
        json['DepartmentID'] as int?,
        json['Department'] as String?,
      );

  TicketCategoryEntity toEntity() {
    return TicketCategoryEntity(categoryID, category, departmentID, department);
  }
}
