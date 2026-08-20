import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entity.dart';

class TicketWorkflowResponseModel {
  final int? status;
  final String? message;
  final List<TicketWorkflow>? ticketWorkflow;

  TicketWorkflowResponseModel({this.status, this.message, this.ticketWorkflow});

  factory TicketWorkflowResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketWorkflowResponseModel(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      ticketWorkflow: json['TicketWorkflow'] != null
          ? (json['TicketWorkflow'] as List)
                .map((v) => TicketWorkflow.fromJson(v))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (ticketWorkflow != null) {
      data['TicketWorkflow'] = ticketWorkflow!
          .map((v) => (v as TicketWorkflow).toJson())
          .toList();
    }
    return data;
  }
}

class TicketWorkflow extends TicketWorkflowEntity {
  TicketWorkflow({super.level, super.userName, super.groupName});

  factory TicketWorkflow.fromJson(Map<String, dynamic> json) {
    return TicketWorkflow(
      level: json['Level'] as int?,
      userName: json['UserName'] as String?,
      groupName: json['GroupName'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Level'] = level;
    data['UserName'] = userName;
    data['GroupName'] = groupName;
    return data;
  }
}
