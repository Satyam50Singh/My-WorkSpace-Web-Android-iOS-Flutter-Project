import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_detail.dart';

class TicketDetailModel extends TicketDetail {
  TicketDetailModel({
    super.totalRecords,
    super.totalPages,
    super.ticketDetailList,
    super.ticketRequestCount,
  });

  factory TicketDetailModel.fromJson(Map<String, dynamic> json) {
    return TicketDetailModel(
      totalRecords: json['TotalRecords'] as int?,
      totalPages: json['TotalPages'] as int?,
      ticketDetailList: json['TicketDetails'] != null
          ? (json['TicketDetails'] as List)
              .map((i) => TicketDetailListModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
      ticketRequestCount: json['TicketRequestCount'] != null
          ? (json['TicketRequestCount'] as List)
              .map((i) => TicketRequestCountModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  TicketDetail toEntity() {
    return TicketDetail(
      totalRecords: totalRecords,
      totalPages: totalPages,
      ticketDetailList: ticketDetailList,
      ticketRequestCount: ticketRequestCount,
    );
  }
}

class TicketDetailListModel extends TicketDetailList {
  TicketDetailListModel({
    super.ticketID,
    super.ticketCode,
    super.level,
    super.ticketDate,
    super.ticketStatus,
    super.ticketActionStatus,
    super.raisedByUser,
    super.raisedByUserProfilePic,
    super.ticketType,
    super.isReviewDone,
    super.category,
    super.subCategory,
    super.lastActionBy,
    super.location,
  });

  factory TicketDetailListModel.fromJson(Map<String, dynamic> json) {
    return TicketDetailListModel(
      ticketID: json['TicketID']?.toString(),
      ticketCode: json['TicketCode']?.toString(),
      level: json['Level']?.toString(),
      ticketDate: json['Ticket_Date']?.toString(),
      ticketStatus: json['Ticket_Status']?.toString(),
      ticketActionStatus: json['Ticket_ActionStatus']?.toString(),
      raisedByUser: json['RaisedByUser']?.toString(),
      raisedByUserProfilePic: json['RaisedByUser_ProfilePic']?.toString(),
      ticketType: json['Ticket_Type']?.toString(),
      isReviewDone: json['Is_Review_Done'] as bool?,
      category: json['Category']?.toString(),
      subCategory: json['SubCategory']?.toString(),
      lastActionBy: json['Last_Action_By']?.toString(),
      location: json['Location']?.toString(),
    );
  }
}

class TicketRequestCountModel extends TicketRequestCount {
  TicketRequestCountModel({
    super.total,
    super.open,
    super.assigned,
    super.accepted,
    super.inProgress,
    super.hold,
    super.closed,
    super.expired,
    super.transferred,
  });

  factory TicketRequestCountModel.fromJson(Map<String, dynamic> json) {
    return TicketRequestCountModel(
      total: json['Total'] as int?,
      open: json['Open'] as int?,
      assigned: json['Assigned'] as int?,
      accepted: json['Accepted'] as int?,
      inProgress: json['InProgress'] as int?,
      hold: json['Hold'] as int?,
      closed: json['Closed'] as int?,
      expired: json['Expired'] as int?,
      transferred: json['Transferred'] as int?,
    );
  }
}
