import 'company_details_model.dart';

class ValidateCompanyCodeResponseModel {
  final int status;
  final String message;
  final List<CompanyDetailsModel> companyDetailList;

  ValidateCompanyCodeResponseModel({
    required this.status,
    required this.message,
    required this.companyDetailList,
  });

  factory ValidateCompanyCodeResponseModel.fromJson(Map<String, dynamic> json) {
    return ValidateCompanyCodeResponseModel(
      status: json['Status'] as int? ?? 0,
      message: json['Message'] as String? ?? "",
      companyDetailList: (json['CompanyDetailList'] as List<dynamic>? ?? [])
          .map((e) => CompanyDetailsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
