class ViewTicketDetailV6Entity {
  int? ticketID;
  String? ticketCode;
  int? level;
  String? ticketDate;
  String? ticketStatus;
  String? ticketActionStatus;
  String? raisedByUser;
  String? raisedByMobileNo;
  String? raisedByEmailID;
  String? locDesc;
  String? categoryDesc;
  String? subCategoryDesc;
  String? assignedDepartment;
  String? ticketMessage;
  String? ticketRaisedImage;
  String? closedByUser;
  String? closureRemarks;
  String? ticketClosureImage;
  bool? isActionAllowed;
  bool? isAcceptAllowed;
  bool? isReopenReviewAllowed;
  bool? isAcceptedByAnotherUser;
  String? acceptedByUser;
  String? ticketType;
  String? checklistQuestion;
  String? userResponse;
  bool? isReviewDone;
  String? reviewedBy;
  String? reviewedDate;
  String? reviewedRemarks;
  int? assetID;
  String? assetName;

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
