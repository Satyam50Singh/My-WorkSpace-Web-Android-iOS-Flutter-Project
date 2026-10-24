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
    this.workflowDetailId,
    this.userId,
    this.groupId = 0,
    this.escalateTime,
    this.isEmail = 0,
    this.isSMS = 0,
    this.isAppNotification = 0,
    this.isWebNotification = 0,
  });

  factory WorkflowLevelModel.fromJson(Map<String, dynamic> json) {
    return WorkflowLevelModel(
      level: json['Level'] as int? ?? 1,
      workflowDetailId: json['Workflow_Detail_Id'] as int? ??
          json['WorkflowDetailID'] as int? ??
          0,
      userId: json['UserIDs'] as String? ?? json['UserID'] as String?,
      groupId: json['GroupID'] as int? ?? 0,
      escalateTime: json['Escalate_Time'] as int? ??
          json['EscalateTime'] as int?,
      isEmail: json['Is_Email'] as int? ?? json['IsEmail'] as int? ?? 0,
      isSMS: json['Is_SMS'] as int? ?? json['IsSMS'] as int? ?? 0,
      isAppNotification: json['Is_AppNotification'] as int? ??
          json['IsAppNotification'] as int? ??
          0,
      isWebNotification: json['Is_WebNotification'] as int? ??
          json['IsWebNotification'] as int? ??
          0,
    );
  }

  Map<String, dynamic> toJson() {
    final formattedUserId =
        (userId != null && userId!.isNotEmpty && userId != "0")
            ? userId!
            : "0";

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
