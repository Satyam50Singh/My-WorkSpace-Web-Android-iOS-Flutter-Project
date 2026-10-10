import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/department_entity.dart';

class FetchDepartmentListResponseModel {
  int? status;
  String? message;
  List<DepartmentModel>? departmentList;

  FetchDepartmentListResponseModel({
    this.status,
    this.message,
    this.departmentList,
  });

  factory FetchDepartmentListResponseModel.fromJson(Map<String, dynamic> json) {
    return FetchDepartmentListResponseModel(
      status: json['Status'] as int? ?? 0,
      message: json['Message'] as String? ?? "",
      departmentList: json['Departments'] != null
          ? (json['Departments'] as List)
                .map((i) => DepartmentModel.fromJson(i as Map<String, dynamic>))
                .toList()
          : null,
    );
  }
}

class DepartmentModel extends DepartmentEntity {
  DepartmentModel(super.departmentID, super.department);

  DepartmentModel.fromJson(Map<String, dynamic> json)
    : super(json['DepartmentID'] as int?, json['Department'] as String?);

  DepartmentEntity toEntity() {
    return DepartmentEntity(departmentID, department);
  }
}
