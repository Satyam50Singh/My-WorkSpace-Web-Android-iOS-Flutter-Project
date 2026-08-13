class TicketDetail {
  final int? totalRecords;
  final int? totalPages;
  final List<TicketDetailList>? ticketDetailList;
  final List<TicketRequestCount>? ticketRequestCount;

  TicketDetail({
    this.totalRecords,
    this.totalPages,
    this.ticketDetailList,
    this.ticketRequestCount,
  });
}

class TicketDetailList {
  final String? ticketID;
  final String? ticketCode;
  final String? level;
  final String? ticketDate;
  final String? ticketStatus;
  final String? ticketActionStatus;
  final String? raisedByUser;
  final String? raisedByUserProfilePic;
  final String? ticketType;
  final bool? isReviewDone;
  final String? category;
  final String? subCategory;
  final String? lastActionBy;
  final String? location;

  TicketDetailList({
    this.ticketID,
    this.ticketCode,
    this.level,
    this.ticketDate,
    this.ticketStatus,
    this.ticketActionStatus,
    this.raisedByUser,
    this.raisedByUserProfilePic,
    this.ticketType,
    this.isReviewDone,
    this.category,
    this.subCategory,
    this.lastActionBy,
    this.location,
  });
}

class TicketRequestCount {
  int? total;
  int? open;
  int? assigned;
  int? accepted;
  int? inProgress;
  int? hold;
  int? closed;
  int? expired;
  int? transferred;

  TicketRequestCount({
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
