import '../../../domain/entities/view_ticket_detail_entities/ticket_history_entity.dart';

class ViewTicketActionHistoryResponseModel {
  final int? status;
  final String? message;
  final List<TicketHistoryModel>? ticketHistory;

  ViewTicketActionHistoryResponseModel({
    this.status,
    this.message,
    this.ticketHistory,
  });

  factory ViewTicketActionHistoryResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ViewTicketActionHistoryResponseModel(
      status: json['Status'],
      message: json['Message'],
      ticketHistory: json['TicketHistory'] != null
          ? (json['TicketHistory'] as List)
                .map((i) => TicketHistoryModel.fromJson(i))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'TicketHistory': ticketHistory?.map((e) => e.toJson()).toList(),
    };
  }
}

class TicketHistoryModel extends TicketHistoryEntity {
  TicketHistoryModel({
    super.level,
    super.userName,
    super.userProfilePic,
    super.remarks,
    super.actionDateTime,
    super.expectedDateTime,
    super.ticketStatus,
    super.ticketActionStatus,
    super.userMobileNo,
  });

  factory TicketHistoryModel.fromJson(Map<String, dynamic> json) {
    return TicketHistoryModel(
      level: json['Level'],
      userName: json['UserName'],
      userProfilePic: json['User_ProfilePic'],
      remarks: json['Remarks'],
      actionDateTime: json['ActionDateTime'],
      expectedDateTime: json['ExpectedDateTime'],
      ticketStatus: json['Ticket_Status'],
      ticketActionStatus: json['Ticket_ActionStatus'],
      userMobileNo: json['User_MobileNo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Level': level,
      'UserName': userName,
      'User_ProfilePic': userProfilePic,
      'Remarks': remarks,
      'ActionDateTime': actionDateTime,
      'ExpectedDateTime': expectedDateTime,
      'Ticket_Status': ticketStatus,
      'Ticket_ActionStatus': ticketActionStatus,
      'User_MobileNo': userMobileNo,
    };
  }

  TicketHistoryEntity toEntity() {
    return TicketHistoryEntity(
      level: level,
      userName: userName,
      userProfilePic: userProfilePic,
      remarks: remarks,
      actionDateTime: actionDateTime,
      expectedDateTime: expectedDateTime,
      ticketStatus: ticketStatus,
      ticketActionStatus: ticketActionStatus,
      userMobileNo: userMobileNo,
    );
  }
}
