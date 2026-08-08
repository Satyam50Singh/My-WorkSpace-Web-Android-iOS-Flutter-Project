import 'package:my_worksphere_web/features/auth/domain/entities/company.dart';

class CompanyDetailsModel extends Company {
  CompanyDetailsModel({
    required super.companyId,
    required super.companyName,
    required super.clientUrl,
    required super.moduleIds,
    required super.companyLogo,
  });

  factory CompanyDetailsModel.fromJson(Map<String, dynamic> json) {
    return CompanyDetailsModel(
      companyId: json['CompanyID'] as int,
      companyName: json['CompanyName'] as String? ?? "",
      clientUrl: json['Client_URL'] as String? ?? "",
      moduleIds: (json['Module_ID'] as String? ?? "")
          .split(",")
          .where((e) => e.trim().isNotEmpty)
          .map((e) => int.parse(e))
          .toList(),
      companyLogo: json['Company_Logo'] as String? ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CompanyID': companyId,
      'CompanyName': companyName,
      'Client_URL': clientUrl,
      'Module_ID': moduleIds.join(","),
      'Company_Logo': companyLogo,
    };
  }
}
