import 'dart:convert';

import 'package:my_worksphere_web/features/auth/data/models/employee_login/employee_details_model.dart';
import 'package:my_worksphere_web/features/auth/domain/entities/employee_detail.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<EmployeeDetail?> getCachedEmployeeDetails();

  Future<void> saveEmployeeDetails(EmployeeDetailsModel employeeDetail);

  Future<void> clearEmployeeDetails();
}

class AuthLocalDataSourceImpl extends AuthLocalDataSource {
  final SharedPreferences prefs;
  static const employeeDetailKey = "employee_detail";

  AuthLocalDataSourceImpl(this.prefs);

  @override
  Future<EmployeeDetail?> getCachedEmployeeDetails() {
    final employeeDetailJson = prefs.getString(employeeDetailKey);
    if (employeeDetailJson != null) {
      return Future.value(
        EmployeeDetailsModel.fromJson(jsonDecode(employeeDetailJson)),
      );
    } else {
      return Future.value(null);
    }
  }

  @override
  Future<void> saveEmployeeDetails(EmployeeDetailsModel employeeDetail) {
    final employeeDetailJson = jsonEncode(employeeDetail.toJson());
    return prefs.setString(employeeDetailKey, employeeDetailJson);
  }

  @override
  Future<void> clearEmployeeDetails() {
    return prefs.remove(employeeDetailKey);
  }
}
