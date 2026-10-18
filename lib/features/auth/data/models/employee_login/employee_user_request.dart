class EmployeeUserRequest {
  final String username;
  final String password;
  final String userType;
  final int companyId;

  EmployeeUserRequest({
    required this.username,
    required this.password,
    required this.userType,
    required this.companyId,
  });

  Map<String, dynamic> toJson() {
    return {
      'Username': username,
      'Password': password,
      'UserType': userType,
      'CompanyId': companyId,
    };
  }
}
