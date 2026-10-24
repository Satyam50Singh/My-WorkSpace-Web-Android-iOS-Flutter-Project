import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/workflow_user_group_list_entity.dart';

class WorkflowUserGroupListResponseModel extends WorkflowUserGroupListEntity {
  const WorkflowUserGroupListResponseModel({
    super.status,
    super.message,
    super.userList,
    super.groupList,
    super.checklistList,
  });

  factory WorkflowUserGroupListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return WorkflowUserGroupListResponseModel(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      userList: json['User_List'] != null
          ? (json['User_List'] as List)
                .map(
                  (e) =>
                      WorkflowUserItemModel.fromJson(e as Map<String, dynamic>),
                )
                .toList()
          : null,
      groupList: json['Group_List'] != null
          ? (json['Group_List'] as List)
                .map(
                  (e) => WorkflowGroupItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
      checklistList: json['Checklist_List'] != null
          ? (json['Checklist_List'] as List)
                .map(
                  (e) => WorkflowChecklistItemModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'User_List': userList
          ?.map(
            (e) => (e is WorkflowUserItemModel)
                ? e.toJson()
                : WorkflowUserItemModel(
                    userID: e.userID,
                    userName: e.userName,
                    userCode: e.userCode,
                    department: e.department,
                  ).toJson(),
          )
          .toList(),
      'Group_List': groupList
          ?.map(
            (e) => (e is WorkflowGroupItemModel)
                ? e.toJson()
                : WorkflowGroupItemModel(
                    groupID: e.groupID,
                    groupName: e.groupName,
                    groupUsers: e.groupUsers,
                  ).toJson(),
          )
          .toList(),
      'Checklist_List': checklistList
          ?.map(
            (e) => (e is WorkflowChecklistItemModel)
                ? e.toJson()
                : WorkflowChecklistItemModel(
                    chkConfigID: e.chkConfigID,
                    checklistName: e.checklistName,
                  ).toJson(),
          )
          .toList(),
    };
  }

  WorkflowUserGroupListEntity toEntity() {
    return WorkflowUserGroupListEntity(
      status: status,
      message: message,
      userList: userList,
      groupList: groupList,
      checklistList: checklistList,
    );
  }
}

class WorkflowUserItemModel extends WorkflowUserItemEntity {
  WorkflowUserItemModel({
    super.userID,
    super.userName,
    super.userCode,
    super.department,
  });

  factory WorkflowUserItemModel.fromJson(Map<String, dynamic> json) {
    return WorkflowUserItemModel(
      userID: json['UserID'] as int?,
      userName: json['User_Name'] as String?,
      userCode: json['User_Code'] as String?,
      department: json['Department'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'UserID': userID,
      'User_Name': userName,
      'User_Code': userCode,
      'Department': department,
    };
  }

  WorkflowUserItemEntity toEntity() {
    return WorkflowUserItemEntity(
      userID: userID,
      userName: userName,
      userCode: userCode,
      department: department,
    );
  }
}

class WorkflowGroupItemModel extends WorkflowGroupItemEntity {
  WorkflowGroupItemModel({super.groupID, super.groupName, super.groupUsers});

  factory WorkflowGroupItemModel.fromJson(Map<String, dynamic> json) {
    return WorkflowGroupItemModel(
      groupID: json['GroupID'] as int?,
      groupName: json['Group_Name'] as String?,
      groupUsers: json['Group_Users'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'GroupID': groupID,
      'Group_Name': groupName,
      'Group_Users': groupUsers,
    };
  }

  WorkflowGroupItemEntity toEntity() {
    return WorkflowGroupItemEntity(
      groupID: groupID,
      groupName: groupName,
      groupUsers: groupUsers,
    );
  }
}

class WorkflowChecklistItemModel extends WorkflowChecklistItemEntity {
  const WorkflowChecklistItemModel({super.chkConfigID, super.checklistName});

  factory WorkflowChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return WorkflowChecklistItemModel(
      chkConfigID: json['Chk_Config_ID'] as int?,
      checklistName: json['ChecklistName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {'Chk_Config_ID': chkConfigID, 'ChecklistName': checklistName};
  }

  WorkflowChecklistItemEntity toEntity() {
    return WorkflowChecklistItemEntity(
      chkConfigID: chkConfigID,
      checklistName: checklistName,
    );
  }
}
