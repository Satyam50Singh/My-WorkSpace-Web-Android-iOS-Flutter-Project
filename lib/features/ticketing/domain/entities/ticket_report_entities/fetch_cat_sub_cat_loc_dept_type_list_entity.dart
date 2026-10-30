class FetchCatSubCatLocDeptTypeListEntity {
  final int? status;
  final String? message;
  final List<TicketReportCategoryEntity>? category;
  final List<TicketReportSubCategoryEntity>? subcategory;
  final List<TicketReportLocationEntity>? location;
  final List<TicketReportDepartmentEntity>? department;
  final List<TicketReportTicketTypeEntity>? ticketType;

  const FetchCatSubCatLocDeptTypeListEntity({
    this.status,
    this.message,
    this.category,
    this.subcategory,
    this.location,
    this.department,
    this.ticketType,
  });
}

class TicketReportCategoryEntity {
  final int? categoryID;
  final String? categoryDesc;

  const TicketReportCategoryEntity({
    this.categoryID,
    this.categoryDesc,
  });
}

class TicketReportSubCategoryEntity {
  final int? subCategoryID;
  final int? categoryID;
  final String? subCategoryDesc;

  const TicketReportSubCategoryEntity({
    this.subCategoryID,
    this.categoryID,
    this.subCategoryDesc,
  });
}

class TicketReportLocationEntity {
  final int? locationID;
  final String? locationDesc;

  const TicketReportLocationEntity({
    this.locationID,
    this.locationDesc,
  });
}

class TicketReportDepartmentEntity {
  final int? departmentID;
  final String? department;

  const TicketReportDepartmentEntity({
    this.departmentID,
    this.department,
  });
}

class TicketReportTicketTypeEntity {
  final String? ticketType;
  final String? ticketTypeID;

  const TicketReportTicketTypeEntity({
    this.ticketType,
    this.ticketTypeID,
  });
}
