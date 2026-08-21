import 'package:my_worksphere_web/features/ticketing/domain/entities/view_ticket_detail_v6.dart';

class ViewTicketDetailsV6ResponseModel {
  final int? status;
  final String? message;
  final List<ViewTicketDetailV6Model>? ticketDetails;

  ViewTicketDetailsV6ResponseModel({
    this.status,
    this.message,
    this.ticketDetails,
  });

  factory ViewTicketDetailsV6ResponseModel.fromJson(Map<String, dynamic> json) {
    return ViewTicketDetailsV6ResponseModel(
      status: json['Status'] as int?,
      message: json['Message'] as String?,
      ticketDetails: json['TicketDetails'] != null
          ? (json['TicketDetails'] as List)
                .map((v) => ViewTicketDetailV6Model.fromJson(v))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Status'] = status;
    data['Message'] = message;
    if (ticketDetails != null) {
      data['TicketDetails'] = ticketDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ViewTicketDetailV6Model extends ViewTicketDetailV6Entity {
  ViewTicketDetailV6Model({
    super.ticketID,
    super.ticketCode,
    super.level,
    super.ticketDate,
    super.ticketStatus,
    super.ticketActionStatus,
    super.raisedByUser,
    super.raisedByMobileNo,
    super.raisedByEmailID,
    super.locDesc,
    super.categoryDesc,
    super.subCategoryDesc,
    super.assignedDepartment,
    super.ticketMessage,
    super.ticketRaisedImage,
    super.closedByUser,
    super.closureRemarks,
    super.ticketClosureImage,
    super.isActionAllowed,
    super.isAcceptAllowed,
    super.isReopenReviewAllowed,
    super.isAcceptedByAnotherUser,
    super.acceptedByUser,
    super.ticketType,
    super.checklistQuestion,
    super.userResponse,
    super.isReviewDone,
    super.reviewedBy,
    super.reviewedDate,
    super.reviewedRemarks,
    super.assetID,
    super.assetName,
  });

  factory ViewTicketDetailV6Model.fromJson(Map<String, dynamic> json) {
    return ViewTicketDetailV6Model(
      ticketID: json['TicketID'],
      ticketCode: json['TicketCode'],
      level: json['Level'],
      ticketDate: json['Ticket_Date'],
      ticketStatus: json['Ticket_Status'],
      ticketActionStatus: json['Ticket_ActionStatus'],
      raisedByUser: json['RaisedByUser'],
      raisedByMobileNo: json['RaisedByMobileNo'],
      raisedByEmailID: json['RaisedByEmailID'],
      locDesc: json['Loc_Desc'],
      categoryDesc: json['Category_Desc'],
      subCategoryDesc: json['SubCategory_Desc'],
      assignedDepartment: json['Assigned_Department'],
      ticketMessage: json['Ticket_Message'],
      ticketRaisedImage: json['TicketRaised_Image'],
      closedByUser: json['ClosedByUser'],
      closureRemarks: json['Closure_Remarks'],
      ticketClosureImage: json['TicketClosure_Image'],
      isActionAllowed: json['Is_Action_Allowed'],
      isAcceptAllowed: json['Is_Accept_Allowed'],
      isReopenReviewAllowed: json['Is_Reopen_Review_Allowed'],
      isAcceptedByAnotherUser: json['Is_AcceptedByAnotherUser'],
      acceptedByUser: json['AcceptedByUser'],
      ticketType: json['Ticket_Type'],
      checklistQuestion: json['Checklist_Question'],
      userResponse: json['User_Response'],
      isReviewDone: json['Is_Review_Done'],
      reviewedBy: json['Reviewed_By'],
      reviewedDate: json['Reviewed_Date'],
      reviewedRemarks: json['Reviewed_Remarks'],
      assetID: json['AssetID'],
      assetName: json['Asset_Name'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['TicketID'] = ticketID;
    data['TicketCode'] = ticketCode;
    data['Level'] = level;
    data['Ticket_Date'] = ticketDate;
    data['Ticket_Status'] = ticketStatus;
    data['Ticket_ActionStatus'] = ticketActionStatus;
    data['RaisedByUser'] = raisedByUser;
    data['RaisedByMobileNo'] = raisedByMobileNo;
    data['RaisedByEmailID'] = raisedByEmailID;
    data['Loc_Desc'] = locDesc;
    data['Category_Desc'] = categoryDesc;
    data['SubCategory_Desc'] = subCategoryDesc;
    data['Assigned_Department'] = assignedDepartment;
    data['Ticket_Message'] = ticketMessage;
    data['TicketRaised_Image'] = ticketRaisedImage;
    data['ClosedByUser'] = closedByUser;
    data['Closure_Remarks'] = closureRemarks;
    data['TicketClosure_Image'] = ticketClosureImage;
    data['Is_Action_Allowed'] = isActionAllowed;
    data['Is_Accept_Allowed'] = isAcceptAllowed;
    data['Is_Reopen_Review_Allowed'] = isReopenReviewAllowed;
    data['Is_AcceptedByAnotherUser'] = isAcceptedByAnotherUser;
    data['AcceptedByUser'] = acceptedByUser;
    data['Ticket_Type'] = ticketType;
    data['Checklist_Question'] = checklistQuestion;
    data['User_Response'] = userResponse;
    data['Is_Review_Done'] = isReviewDone;
    data['Reviewed_By'] = reviewedBy;
    data['Reviewed_Date'] = reviewedDate;
    data['Reviewed_Remarks'] = reviewedRemarks;
    data['AssetID'] = assetID;
    data['Asset_Name'] = assetName;
    return data;
  }

  ViewTicketDetailV6Entity toEntity() {
    return ViewTicketDetailV6Entity(
      ticketID: ticketID,
      ticketCode: ticketCode,
      level: level,
      ticketDate: ticketDate,
      ticketStatus: ticketStatus,
      ticketActionStatus: ticketActionStatus,
      raisedByUser: raisedByUser,
      raisedByMobileNo: raisedByMobileNo,
      raisedByEmailID: raisedByEmailID,
      locDesc: locDesc,
      categoryDesc: categoryDesc,
      subCategoryDesc: subCategoryDesc,
      assignedDepartment: assignedDepartment,
      ticketMessage: ticketMessage,
      ticketRaisedImage: ticketRaisedImage,
      closedByUser: closedByUser,
      closureRemarks: closureRemarks,
      ticketClosureImage: ticketClosureImage,
      isActionAllowed: isActionAllowed,
      isAcceptAllowed: isAcceptAllowed,
      isReopenReviewAllowed: isReopenReviewAllowed,
      isAcceptedByAnotherUser: isAcceptedByAnotherUser,
      acceptedByUser: acceptedByUser,
      ticketType: ticketType,
      checklistQuestion: checklistQuestion,
      userResponse: userResponse,
      isReviewDone: isReviewDone,
      reviewedBy: reviewedBy,
      reviewedDate: reviewedDate,
      reviewedRemarks: reviewedRemarks,
      assetID: assetID,
      assetName: assetName,
    );
  }
}
