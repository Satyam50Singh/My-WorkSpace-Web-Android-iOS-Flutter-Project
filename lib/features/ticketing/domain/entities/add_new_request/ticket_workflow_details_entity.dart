class TicketWorkflowDetailsEntity {
  List<TicketWorkflowEntity>? workFlowDetailList;

  TicketWorkflowDetailsEntity({this.workFlowDetailList});
}

class TicketWorkflowEntity {
  final int? level;
  final String? userName;
  final String? groupName;
  final String? userID;
  final int? groupID;
  final String? userProfilePic;
  final int? time;
  final int? totalUsers;
  final List<WorkflowUserEntity>? workflowUsers;

  TicketWorkflowEntity({
    this.level,
    this.userName,
    this.groupName,
    this.userID,
    this.groupID,
    this.userProfilePic,
    this.time,
    this.totalUsers,
    this.workflowUsers,
  });
}

class WorkflowUserEntity {
  final String? userName;
  final String? profileImage;

  WorkflowUserEntity({this.userName, this.profileImage});
}
