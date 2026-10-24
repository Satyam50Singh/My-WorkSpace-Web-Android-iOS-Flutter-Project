class WorkflowUserGroupListEntity {
  final int? status;
  final String? message;
  final List<WorkflowUserItemEntity>? userList;
  final List<WorkflowGroupItemEntity>? groupList;
  final List<WorkflowChecklistItemEntity>? checklistList;

  const WorkflowUserGroupListEntity({
    this.status,
    this.message,
    this.userList,
    this.groupList,
    this.checklistList,
  });
}

class WorkflowUserItemEntity {
  final int? userID;
  final String? userName;
  final String? userCode;
  final String? department;
  bool isSelected;

  WorkflowUserItemEntity({
    this.userID,
    this.userName,
    this.userCode,
    this.department,
    this.isSelected = false,
  });
}

class WorkflowGroupItemEntity {
  final int? groupID;
  final String? groupName;
  final String? groupUsers;
  bool isSelected;

  WorkflowGroupItemEntity({
    this.groupID,
    this.groupName,
    this.groupUsers,
    this.isSelected = false,
  });
}

class WorkflowChecklistItemEntity {
  final int? chkConfigID;
  final String? checklistName;

  const WorkflowChecklistItemEntity({this.chkConfigID, this.checklistName});
}
