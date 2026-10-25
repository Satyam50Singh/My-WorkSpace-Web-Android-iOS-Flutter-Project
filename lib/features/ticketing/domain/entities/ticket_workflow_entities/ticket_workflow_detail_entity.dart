import 'ticket_workflow_master_entity.dart';

class TicketWorkflowDetailEntity {
  final int? status;
  final String? message;
  final TicketWorkflowMasterEntity? workflow;
  final List<WorkflowDetailItemEntity>? workflowDetails;

  const TicketWorkflowDetailEntity({
    this.status,
    this.message,
    this.workflow,
    this.workflowDetails,
  });
}

class WorkflowDetailItemEntity {
  final int? workflowDetailId;
  final int? level;
  final String? userIDs;
  final int? groupID;
  final String? userGroupName;
  final int? escalateTime;
  final int? isEmail;
  final int? isSMS;
  final int? isAppNotification;
  final int? isWebNotification;

  const WorkflowDetailItemEntity({
    this.workflowDetailId,
    this.level,
    this.userIDs,
    this.groupID,
    this.userGroupName,
    this.escalateTime,
    this.isEmail,
    this.isSMS,
    this.isAppNotification,
    this.isWebNotification,
  });
}
