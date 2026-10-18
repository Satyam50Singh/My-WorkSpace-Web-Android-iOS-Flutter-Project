import 'employee_details_model.dart';

class EmployerLoginResponseModel {
  final int status;
  final String message;
  final List<EmployeeDetailsModel> userDetailsList;
  final List<JwtToken> jwtToken;

  EmployerLoginResponseModel({
    required this.status,
    required this.message,
    required this.userDetailsList,
    required this.jwtToken,
  });

  factory EmployerLoginResponseModel.fromJson(Map<String, dynamic> json) {
    return EmployerLoginResponseModel(
      status: json['Status'] as int? ?? 0,
      message: json['Message'] as String? ?? "",
      userDetailsList: (json['LoginDetails'] as List<dynamic>? ?? [])
          .map((e) => EmployeeDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      jwtToken: (json['JwtToken'] as List<dynamic>? ?? [])
          .map((e) => JwtToken.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class JwtToken {
  final String token;

  JwtToken({required this.token});

  factory JwtToken.fromJson(Map<String, dynamic> json) {
    return JwtToken(token: json['JwtToken'] as String? ?? "");
  }
}
