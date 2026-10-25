class WorkflowLevelModel {
  int level;
  int? workflowDetailId;
  String? userId;
  int? groupId;
  int? escalateTime;
  int? isEmail;
  int? isSMS;
  int? isAppNotification;
  int? isWebNotification;

  WorkflowLevelModel({
    required this.level,
    this.workflowDetailId = 0,
    this.userId = "0",
    this.groupId = 0,
    this.escalateTime = 0,
    this.isEmail = 0,
    this.isSMS = 0,
    this.isAppNotification = 0,
    this.isWebNotification = 0,
  });

  Map<String, dynamic> toJson() {
    final formattedUserId =
        (userId != null && userId!.isNotEmpty && userId != "0") ? userId! : "0";
    return {
      'Workflow_Detail_Id': workflowDetailId ?? 0,
      'Level': level,
      'UserIDs': formattedUserId,
      'GroupID': groupId ?? 0,
      'Escalate_Time': escalateTime ?? 0,
      'Is_Email': isEmail ?? 0,
      'Is_SMS': isSMS ?? 0,
      'Is_AppNotification': isAppNotification ?? 0,
      'Is_WebNotification': isWebNotification ?? 0,
    };
  }

  @override
  String toString() {
    return 'WorkflowLevelModel(level: $level, workflowDetailId: $workflowDetailId, userId: $userId, groupId: $groupId, escalateTime: $escalateTime, isEmail: $isEmail, isSMS: $isSMS, isAppNotification: $isAppNotification, isWebNotification: $isWebNotification)';
  }
}
