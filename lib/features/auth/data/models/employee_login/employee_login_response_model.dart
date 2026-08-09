import 'employee_details_model.dart';

class EmployerLoginResponseModel {
  final int status;
  final String message;
  final List<EmployeeDetailsModel> userDetailsList;

  EmployerLoginResponseModel({
    required this.status,
    required this.message,
    required this.userDetailsList,
  });

  factory EmployerLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return EmployerLoginResponseModel(
      status: json['Status'] as int? ?? 0,
      message: json['Message'] as String? ?? "",
      userDetailsList: (json['LoginDetails'] as List<dynamic>? ?? [])
          .map((e) => EmployeeDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
