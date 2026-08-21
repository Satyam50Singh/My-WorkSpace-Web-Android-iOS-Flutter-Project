import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entity.dart';

class TicketWorkflowResponseModel {
  final int? status;
  final String? message;
  final List<TicketWorkflowModel>? ticketWorkflow;

  TicketWorkflowResponseModel({this.status, this.message, this.ticketWorkflow});

  factory TicketWorkflowResponseModel.fromJson(Map<String, dynamic> json) {
    return TicketWorkflowResponseModel(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      ticketWorkflow: json['TicketWorkflow'] != null
          ? (json['TicketWorkflow'] as List)
                .map((v) => TicketWorkflowModel.fromJson(v))
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
          .map((v) => v.toJson())
          .toList();
    }
    return data;
  }
}

class TicketWorkflowModel extends TicketWorkflowEntity {
  TicketWorkflowModel({super.level, super.userName, super.groupName});

  factory TicketWorkflowModel.fromJson(Map<String, dynamic> json) {
    return TicketWorkflowModel(
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

  TicketWorkflowEntity toEntity() {
    return TicketWorkflowEntity(
      level: level,
      userName: userName,
      groupName: groupName,
    );
  }
}
