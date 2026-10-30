import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_report_entities/fetch_cat_sub_cat_loc_dept_type_list_entity.dart';

class FetchCatSubCatLocDeptTypeListResponseModel
    extends FetchCatSubCatLocDeptTypeListEntity {
  const FetchCatSubCatLocDeptTypeListResponseModel({
    super.status,
    super.message,
    super.category,
    super.subcategory,
    super.location,
    super.department,
    super.ticketType,
  });

  factory FetchCatSubCatLocDeptTypeListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FetchCatSubCatLocDeptTypeListResponseModel(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      category: json['category'] != null
          ? (json['category'] as List)
              .map((i) =>
                  TicketReportCategoryModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
      subcategory: json['subcategory'] != null
          ? (json['subcategory'] as List)
              .map((i) => TicketReportSubCategoryModel.fromJson(
                  i as Map<String, dynamic>))
              .toList()
          : null,
      location: json['location'] != null
          ? (json['location'] as List)
              .map((i) =>
                  TicketReportLocationModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
      department: json['department'] != null
          ? (json['department'] as List)
              .map((i) => TicketReportDepartmentModel.fromJson(
                  i as Map<String, dynamic>))
              .toList()
          : null,
      ticketType: json['ticket_type'] != null
          ? (json['ticket_type'] as List)
              .map((i) => TicketReportTicketTypeModel.fromJson(
                  i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'category': category
          ?.map((e) => (e is TicketReportCategoryModel)
              ? e.toJson()
              : TicketReportCategoryModel(
                  categoryID: e.categoryID,
                  categoryDesc: e.categoryDesc,
                ).toJson())
          .toList(),
      'subcategory': subcategory
          ?.map((e) => (e is TicketReportSubCategoryModel)
              ? e.toJson()
              : TicketReportSubCategoryModel(
                  subCategoryID: e.subCategoryID,
                  categoryID: e.categoryID,
                  subCategoryDesc: e.subCategoryDesc,
                ).toJson())
          .toList(),
      'location': location
          ?.map((e) => (e is TicketReportLocationModel)
              ? e.toJson()
              : TicketReportLocationModel(
                  locationID: e.locationID,
                  locationDesc: e.locationDesc,
                ).toJson())
          .toList(),
      'department': department
          ?.map((e) => (e is TicketReportDepartmentModel)
              ? e.toJson()
              : TicketReportDepartmentModel(
                  departmentID: e.departmentID,
                  department: e.department,
                ).toJson())
          .toList(),
      'ticket_type': ticketType
          ?.map((e) => (e is TicketReportTicketTypeModel)
              ? e.toJson()
              : TicketReportTicketTypeModel(
                  ticketType: e.ticketType,
                  ticketTypeID: e.ticketTypeID,
                ).toJson())
          .toList(),
    };
  }

  FetchCatSubCatLocDeptTypeListEntity toEntity() {
    return FetchCatSubCatLocDeptTypeListEntity(
      status: status,
      message: message,
      category: category,
      subcategory: subcategory,
      location: location,
      department: department,
      ticketType: ticketType,
    );
  }
}

class TicketReportCategoryModel extends TicketReportCategoryEntity {
  const TicketReportCategoryModel({
    super.categoryID,
    super.categoryDesc,
  });

  factory TicketReportCategoryModel.fromJson(Map<String, dynamic> json) {
    return TicketReportCategoryModel(
      categoryID: json['CategoryID'] as int?,
      categoryDesc: json['Category_Desc'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CategoryID': categoryID,
      'Category_Desc': categoryDesc,
    };
  }

  TicketReportCategoryEntity toEntity() {
    return TicketReportCategoryEntity(
      categoryID: categoryID,
      categoryDesc: categoryDesc,
    );
  }
}

class TicketReportSubCategoryModel extends TicketReportSubCategoryEntity {
  const TicketReportSubCategoryModel({
    super.subCategoryID,
    super.categoryID,
    super.subCategoryDesc,
  });

  factory TicketReportSubCategoryModel.fromJson(Map<String, dynamic> json) {
    return TicketReportSubCategoryModel(
      subCategoryID: json['SubCategory_ID'] as int?,
      categoryID: json['Category_ID'] as int?,
      subCategoryDesc: json['SubCategory_Desc'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'SubCategory_ID': subCategoryID,
      'Category_ID': categoryID,
      'SubCategory_Desc': subCategoryDesc,
    };
  }

  TicketReportSubCategoryEntity toEntity() {
    return TicketReportSubCategoryEntity(
      subCategoryID: subCategoryID,
      categoryID: categoryID,
      subCategoryDesc: subCategoryDesc,
    );
  }
}

class TicketReportLocationModel extends TicketReportLocationEntity {
  const TicketReportLocationModel({
    super.locationID,
    super.locationDesc,
  });

  factory TicketReportLocationModel.fromJson(Map<String, dynamic> json) {
    return TicketReportLocationModel(
      locationID: json['LocationID'] as int?,
      locationDesc: json['Location_Desc'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LocationID': locationID,
      'Location_Desc': locationDesc,
    };
  }

  TicketReportLocationEntity toEntity() {
    return TicketReportLocationEntity(
      locationID: locationID,
      locationDesc: locationDesc,
    );
  }
}

class TicketReportDepartmentModel extends TicketReportDepartmentEntity {
  const TicketReportDepartmentModel({
    super.departmentID,
    super.department,
  });

  factory TicketReportDepartmentModel.fromJson(Map<String, dynamic> json) {
    return TicketReportDepartmentModel(
      departmentID: json['DepartmentID'] as int?,
      department: json['Department'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'DepartmentID': departmentID,
      'Department': department,
    };
  }

  TicketReportDepartmentEntity toEntity() {
    return TicketReportDepartmentEntity(
      departmentID: departmentID,
      department: department,
    );
  }
}

class TicketReportTicketTypeModel extends TicketReportTicketTypeEntity {
  const TicketReportTicketTypeModel({
    super.ticketType,
    super.ticketTypeID,
  });

  factory TicketReportTicketTypeModel.fromJson(Map<String, dynamic> json) {
    return TicketReportTicketTypeModel(
      ticketType: json['TicketType'] as String?,
      ticketTypeID: json['TicketType_ID'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TicketType': ticketType,
      'TicketType_ID': ticketTypeID,
    };
  }

  TicketReportTicketTypeEntity toEntity() {
    return TicketReportTicketTypeEntity(
      ticketType: ticketType,
      ticketTypeID: ticketTypeID,
    );
  }
}
