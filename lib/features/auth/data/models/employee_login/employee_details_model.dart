import '../../../domain/entities/employee_detail.dart';

class EmployeeDetailsModel extends EmployeeDetail {
  EmployeeDetailsModel({
    super.userID,
    super.companyId,
    super.username,
    super.fullName,
    super.rollCd,
    super.empCd,
    super.profilePic,
    super.departmentID,
    super.roleName,
    super.isFirstLogin,
    super.isRequestToDelete,
    super.isHOD,
    super.hODOfDepartment,
    super.moduleAccess,
  });

  factory EmployeeDetailsModel.fromJson(Map<String, dynamic> json) {
    return EmployeeDetailsModel(
      userID: json['UserID'] as int?,
      companyId: json['CompanyID'] as int?,
      username: json['Username'] as String?,
      fullName: json['FullName'] as String?,
      rollCd: json['RollCd'] as String?,
      empCd: json['EmpCd'] as String?,
      profilePic: json['ProfilePic'] as String?,
      departmentID: json['DepartmentID'] as String?,
      roleName: json['Role_Name'] as String?,
      isFirstLogin: json['Is_First_Login'] as bool?,
      isRequestToDelete: json['Is_Request_To_Delete'] as bool?,
      isHOD: json['Is_HOD'] as bool?,
      hODOfDepartment: json['HOD_Of_Department'] as String?,
      moduleAccess: json['Module_Access'] != null
          ? (json['Module_Access'] as List)
                .map(
                  (i) => ModuleAccessModel.fromJson(i as Map<String, dynamic>),
                )
                .toList()
          : null,
    );
  }

  factory EmployeeDetailsModel.fromEntity(EmployeeDetail employeeDetail) {
    return EmployeeDetailsModel(
      userID: employeeDetail.userID,
      companyId: employeeDetail.companyId,
      username: employeeDetail.username,
      fullName: employeeDetail.fullName,
      rollCd: employeeDetail.rollCd,
      empCd: employeeDetail.empCd,
      profilePic: employeeDetail.profilePic,
      departmentID: employeeDetail.departmentID,
      roleName: employeeDetail.roleName,
      isFirstLogin: employeeDetail.isFirstLogin,
      isRequestToDelete: employeeDetail.isRequestToDelete,
      isHOD: employeeDetail.isHOD,
      hODOfDepartment: employeeDetail.hODOfDepartment,
      moduleAccess: employeeDetail.moduleAccess
          ?.map((e) => ModuleAccessModel.fromEntity(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'CompanyID': companyId,
      'Username': username,
      'FullName': fullName,
      'RollCd': rollCd,
      'EmpCd': empCd,
      'ProfilePic': profilePic,
      'DepartmentID': departmentID,
      'Role_Name': roleName,
      'Is_First_Login': isFirstLogin,
      'Is_Request_To_Delete': isRequestToDelete,
      'Is_HOD': isHOD,
      'HOD_Of_Department': hODOfDepartment,
      'Module_Access': moduleAccess
          ?.map((e) => (e as ModuleAccessModel).toJson())
          .toList(),
    };
  }
}

class ModuleAccessModel extends ModuleAccess {
  ModuleAccessModel({super.moduleID, super.moduleName, super.subModules});

  factory ModuleAccessModel.fromEntity(ModuleAccess moduleAccess) {
    return ModuleAccessModel(
      moduleID: moduleAccess.moduleID,
      moduleName: moduleAccess.moduleName,
      subModules: moduleAccess.subModules
          ?.map((e) => SubModulesModel.fromEntity(e))
          .toList(),
    );
  }

  factory ModuleAccessModel.fromJson(Map<String, dynamic> json) {
    return ModuleAccessModel(
      moduleID: json['ModuleID'] as int?,
      moduleName: json['ModuleName'] as String?,
      subModules: json['Sub_Modules'] != null
          ? (json['Sub_Modules'] as List)
                .map((i) => SubModulesModel.fromJson(i as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ModuleID': moduleID,
      'ModuleName': moduleName,
      'Sub_Modules': subModules
          ?.map((e) => (e as SubModulesModel).toJson())
          .toList(),
    };
  }
}

class SubModulesModel extends SubModules {
  SubModulesModel({super.menuID, super.menu, super.menuKey, super.route});

  factory SubModulesModel.fromEntity(SubModules subModules) {
    return SubModulesModel(
      menuID: subModules.menuID,
      menu: subModules.menu,
      menuKey: subModules.menuKey,
      route: subModules.route,
    );
  }

  factory SubModulesModel.fromJson(Map<String, dynamic> json) {
    return SubModulesModel(
      menuID: json['MenuID'] as int?,
      menu: json['Menu'] as String?,
      menuKey: json['Menu_Key'],
      route: json['Route'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'MenuID': menuID,
      'Menu': menu,
      'Menu_Key': menuKey,
      'Route': route,
    };
  }
}
