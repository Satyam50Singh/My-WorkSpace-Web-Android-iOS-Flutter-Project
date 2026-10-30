class FetchTicketReportWebEntity {
  final int? status;
  final String? message;
  final int? totalRecords;
  final int? totalPages;
  final List<TicketReportDetailEntity>? ticketDetails;
  final List<TicketReportStatusCountEntity>? statusCount;

  const FetchTicketReportWebEntity({
    this.status,
    this.message,
    this.totalRecords,
    this.totalPages,
    this.ticketDetails,
    this.statusCount,
  });
}

class TicketReportDetailEntity {
  final String? ticketID;
  final String? ticketCode;
  final String? tktStatus;
  final String? tktActionStatus;
  final String? ticketDate;
  final String? ticketClosingDateTime;
  final String? location;
  final String? category;
  final String? subCategory;
  final String? assignedToDepartment;
  final String? raisedFromDepartment;
  final String? raisedByUser;
  final String? ticketType;
  final String? ticketRemarks;
  final String? priorityDesc;
  final String? closingRemarks;
  final String? downTime;
  final String? aging;
  final String? acceptedByUser;
  final String? closedByUser;
  final String? holdDuration;

  const TicketReportDetailEntity({
    this.ticketID,
    this.ticketCode,
    this.tktStatus,
    this.tktActionStatus,
    this.ticketDate,
    this.ticketClosingDateTime,
    this.location,
    this.category,
    this.subCategory,
    this.assignedToDepartment,
    this.raisedFromDepartment,
    this.raisedByUser,
    this.ticketType,
    this.ticketRemarks,
    this.priorityDesc,
    this.closingRemarks,
    this.downTime,
    this.aging,
    this.acceptedByUser,
    this.closedByUser,
    this.holdDuration,
  });
}

class TicketReportStatusCountEntity {
  final int? total;
  final int? open;
  final int? assigned;
  final int? accepted;
  final int? inProgress;
  final int? hold;
  final int? closed;
  final int? expired;
  final int? transferred;

  const TicketReportStatusCountEntity({
    this.total,
    this.open,
    this.assigned,
    this.accepted,
    this.inProgress,
    this.hold,
    this.closed,
    this.expired,
    this.transferred,
  });
}
