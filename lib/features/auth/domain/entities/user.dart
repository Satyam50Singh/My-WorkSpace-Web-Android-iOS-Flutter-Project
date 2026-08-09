class User {
  final int? userID;
  final String? username;
  final String? fullName;
  final String? rollCd;
  final String? empCd;
  final String? profilePic;
  final String? departmentID;
  final String? roleName;
  final bool? isFirstLogin;
  final bool? isRequestToDelete;
  final bool? isHOD;
  final String? hODOfDepartment;
  final List<ModuleAccess>? moduleAccess;

  const User({
    this.userID,
    this.username,
    this.fullName,
    this.rollCd,
    this.empCd,
    this.profilePic,
    this.departmentID,
    this.roleName,
    this.isFirstLogin,
    this.isRequestToDelete,
    this.isHOD,
    this.hODOfDepartment,
    this.moduleAccess,
  });
}

class ModuleAccess {
  final int? moduleID;
  final String? moduleName;
  final List<SubModules>? subModules;

  ModuleAccess({this.moduleID, this.moduleName, this.subModules});
}

class SubModules {
  final int? menuID;
  final String? menu;
  final dynamic menuKey;
  final dynamic route;

  SubModules({this.menuID, this.menu, this.menuKey, this.route});
}
