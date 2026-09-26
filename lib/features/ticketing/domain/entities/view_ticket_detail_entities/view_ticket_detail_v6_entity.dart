class ViewTicketDetailV6Entity {
  final int? ticketID;
  final String? ticketCode;
  final int? level;
  final String? ticketDate;
  final String? ticketStatus;
  final String? ticketActionStatus;
  final String? raisedByUser;
  final String? raisedByMobileNo;
  final String? raisedByEmailID;
  final String? locDesc;
  final String? categoryDesc;
  final String? subCategoryDesc;
  final String? assignedDepartment;
  final String? ticketMessage;
  final String? ticketRaisedImage;
  final String? closedByUser;
  final String? closureRemarks;
  final String? ticketClosureImage;
  final bool? isActionAllowed;
  final bool? isAcceptAllowed;
  final bool? isReopenReviewAllowed;
  final bool? isAcceptedByAnotherUser;
  final String? acceptedByUser;
  final String? ticketType;
  final String? checklistQuestion;
  final String? userResponse;
  final bool? isReviewDone;
  final String? reviewedBy;
  final String? reviewedDate;
  final String? reviewedRemarks;
  final int? assetID;
  final String? assetName;

  ViewTicketDetailV6Entity({
    this.ticketID,
    this.ticketCode,
    this.level,
    this.ticketDate,
    this.ticketStatus,
    this.ticketActionStatus,
    this.raisedByUser,
    this.raisedByMobileNo,
    this.raisedByEmailID,
    this.locDesc,
    this.categoryDesc,
    this.subCategoryDesc,
    this.assignedDepartment,
    this.ticketMessage,
    this.ticketRaisedImage,
    this.closedByUser,
    this.closureRemarks,
    this.ticketClosureImage,
    this.isActionAllowed,
    this.isAcceptAllowed,
    this.isReopenReviewAllowed,
    this.isAcceptedByAnotherUser,
    this.acceptedByUser,
    this.ticketType,
    this.checklistQuestion,
    this.userResponse,
    this.isReviewDone,
    this.reviewedBy,
    this.reviewedDate,
    this.reviewedRemarks,
    this.assetID,
    this.assetName,
  });
}
