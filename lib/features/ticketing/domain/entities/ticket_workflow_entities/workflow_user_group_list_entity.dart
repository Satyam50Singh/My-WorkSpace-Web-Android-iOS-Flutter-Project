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

  const WorkflowUserItemEntity({
    this.userID,
    this.userName,
    this.userCode,
    this.department,
  });
}

class WorkflowGroupItemEntity {
  final int? groupID;
  final String? groupName;
  final String? groupUsers;

  const WorkflowGroupItemEntity({
    this.groupID,
    this.groupName,
    this.groupUsers,
  });
}

class WorkflowChecklistItemEntity {
  final int? chkConfigID;
  final String? checklistName;

  const WorkflowChecklistItemEntity({this.chkConfigID, this.checklistName});
}
