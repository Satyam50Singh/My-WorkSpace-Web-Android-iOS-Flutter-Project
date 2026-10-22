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
    this.groupId,
    this.escalateTime,
    this.isEmail,
    this.isSMS,
    this.isAppNotification,
    this.isWebNotification,
  });
}
