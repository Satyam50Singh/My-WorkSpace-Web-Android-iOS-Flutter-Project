import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_report_entities/fetch_ticket_report_web_entity.dart';

class FetchTicketReportWebResponseModel extends FetchTicketReportWebEntity {
  const FetchTicketReportWebResponseModel({
    super.status,
    super.message,
    super.totalRecords,
    super.totalPages,
    super.ticketDetails,
    super.statusCount,
  });

  factory FetchTicketReportWebResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return FetchTicketReportWebResponseModel(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      totalRecords: json['TotalRecords'] as int?,
      totalPages: json['TotalPages'] as int?,
      ticketDetails: json['TicketDetails'] != null
          ? (json['TicketDetails'] as List)
              .map((i) =>
                  TicketReportDetailModel.fromJson(i as Map<String, dynamic>))
              .toList()
          : null,
      statusCount: json['StatusCount'] != null
          ? (json['StatusCount'] as List)
              .map((i) => TicketReportStatusCountModel.fromJson(
                  i as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Status': status,
      'Message': message,
      'TotalRecords': totalRecords,
      'TotalPages': totalPages,
      'TicketDetails': ticketDetails
          ?.map((e) => (e is TicketReportDetailModel)
              ? e.toJson()
              : TicketReportDetailModel(
                  ticketID: e.ticketID,
                  ticketCode: e.ticketCode,
                  tktStatus: e.tktStatus,
                  tktActionStatus: e.tktActionStatus,
                  ticketDate: e.ticketDate,
                  ticketClosingDateTime: e.ticketClosingDateTime,
                  location: e.location,
                  category: e.category,
                  subCategory: e.subCategory,
                  assignedToDepartment: e.assignedToDepartment,
                  raisedFromDepartment: e.raisedFromDepartment,
                  raisedByUser: e.raisedByUser,
                  ticketType: e.ticketType,
                  ticketRemarks: e.ticketRemarks,
                  priorityDesc: e.priorityDesc,
                  closingRemarks: e.closingRemarks,
                  downTime: e.downTime,
                  aging: e.aging,
                  acceptedByUser: e.acceptedByUser,
                  closedByUser: e.closedByUser,
                  holdDuration: e.holdDuration,
                ).toJson())
          .toList(),
      'StatusCount': statusCount
          ?.map((e) => (e is TicketReportStatusCountModel)
              ? e.toJson()
              : TicketReportStatusCountModel(
                  total: e.total,
                  open: e.open,
                  assigned: e.assigned,
                  accepted: e.accepted,
                  inProgress: e.inProgress,
                  hold: e.hold,
                  closed: e.closed,
                  expired: e.expired,
                  transferred: e.transferred,
                ).toJson())
          .toList(),
    };
  }

  FetchTicketReportWebEntity toEntity() {
    return FetchTicketReportWebEntity(
      status: status,
      message: message,
      totalRecords: totalRecords,
      totalPages: totalPages,
      ticketDetails: ticketDetails,
      statusCount: statusCount,
    );
  }
}

class TicketReportDetailModel extends TicketReportDetailEntity {
  const TicketReportDetailModel({
    super.ticketID,
    super.ticketCode,
    super.tktStatus,
    super.tktActionStatus,
    super.ticketDate,
    super.ticketClosingDateTime,
    super.location,
    super.category,
    super.subCategory,
    super.assignedToDepartment,
    super.raisedFromDepartment,
    super.raisedByUser,
    super.ticketType,
    super.ticketRemarks,
    super.priorityDesc,
    super.closingRemarks,
    super.downTime,
    super.aging,
    super.acceptedByUser,
    super.closedByUser,
    super.holdDuration,
  });

  factory TicketReportDetailModel.fromJson(Map<String, dynamic> json) {
    return TicketReportDetailModel(
      ticketID: json['TicketID'] as String?,
      ticketCode: json['TicketCode'] as String?,
      tktStatus: json['Tkt_Status'] as String?,
      tktActionStatus: json['Tkt_ActionStatus'] as String?,
      ticketDate: json['Ticket_Date'] as String?,
      ticketClosingDateTime: json['Ticket_Closing_Date_Time'] as String?,
      location: json['Location'] as String?,
      category: json['Category'] as String?,
      subCategory: json['SubCategory'] as String?,
      assignedToDepartment: json['Assigned_To_Department'] as String?,
      raisedFromDepartment: json['Raised_From_Department'] as String?,
      raisedByUser: json['RaisedByUser'] as String?,
      ticketType: json['Ticket_Type'] as String?,
      ticketRemarks: json['Ticket_Remarks'] as String?,
      priorityDesc: json['Priority_Desc'] as String?,
      closingRemarks: json['Closing_Remarks'] as String?,
      downTime: json['Down_Time'] as String?,
      aging: json['Aging'] as String?,
      acceptedByUser: json['AcceptedByUser'] as String?,
      closedByUser: json['ClosedByUser'] as String?,
      holdDuration: json['HoldDuration'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'TicketID': ticketID,
      'TicketCode': ticketCode,
      'Tkt_Status': tktStatus,
      'Tkt_ActionStatus': tktActionStatus,
      'Ticket_Date': ticketDate,
      'Ticket_Closing_Date_Time': ticketClosingDateTime,
      'Location': location,
      'Category': category,
      'SubCategory': subCategory,
      'Assigned_To_Department': assignedToDepartment,
      'Raised_From_Department': raisedFromDepartment,
      'RaisedByUser': raisedByUser,
      'Ticket_Type': ticketType,
      'Ticket_Remarks': ticketRemarks,
      'Priority_Desc': priorityDesc,
      'Closing_Remarks': closingRemarks,
      'Down_Time': downTime,
      'Aging': aging,
      'AcceptedByUser': acceptedByUser,
      'ClosedByUser': closedByUser,
      'HoldDuration': holdDuration,
    };
  }

  TicketReportDetailEntity toEntity() {
    return TicketReportDetailEntity(
      ticketID: ticketID,
      ticketCode: ticketCode,
      tktStatus: tktStatus,
      tktActionStatus: tktActionStatus,
      ticketDate: ticketDate,
      ticketClosingDateTime: ticketClosingDateTime,
      location: location,
      category: category,
      subCategory: subCategory,
      assignedToDepartment: assignedToDepartment,
      raisedFromDepartment: raisedFromDepartment,
      raisedByUser: raisedByUser,
      ticketType: ticketType,
      ticketRemarks: ticketRemarks,
      priorityDesc: priorityDesc,
      closingRemarks: closingRemarks,
      downTime: downTime,
      aging: aging,
      acceptedByUser: acceptedByUser,
      closedByUser: closedByUser,
      holdDuration: holdDuration,
    );
  }
}

class TicketReportStatusCountModel extends TicketReportStatusCountEntity {
  const TicketReportStatusCountModel({
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

  factory TicketReportStatusCountModel.fromJson(Map<String, dynamic> json) {
    return TicketReportStatusCountModel(
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

  Map<String, dynamic> toJson() {
    return {
      'Total': total,
      'Open': open,
      'Assigned': assigned,
      'Accepted': accepted,
      'InProgress': inProgress,
      'Hold': hold,
      'Closed': closed,
      'Expired': expired,
      'Transferred': transferred,
    };
  }

  TicketReportStatusCountEntity toEntity() {
    return TicketReportStatusCountEntity(
      total: total,
      open: open,
      assigned: assigned,
      accepted: accepted,
      inProgress: inProgress,
      hold: hold,
      closed: closed,
      expired: expired,
      transferred: transferred,
    );
  }
}
