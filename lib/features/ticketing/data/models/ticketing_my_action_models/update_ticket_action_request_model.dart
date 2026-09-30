class UpdateTicketActionRequestModel {
  final String? ticketId;
  final String? closeTicketDesc;
  final String? ticketAction;
  final int? currentLevel;
  final String? empCD;
  final int? companyID;
  final String? holdTillDatetime;
  final String? platformType;
  final int? isImageUploaded;
  final int? imageCount;

  UpdateTicketActionRequestModel({
    this.ticketId,
    this.closeTicketDesc,
    this.ticketAction,
    this.currentLevel,
    this.empCD,
    this.companyID,
    this.holdTillDatetime,
    this.platformType,
    this.isImageUploaded,
    this.imageCount,
  });

  Map<String, dynamic> toJson() {
    return {
      "TicketID": ticketId,
      "CloseTicketDesc": closeTicketDesc,
      "TicketAction": ticketAction,
      "CurrentLevel": currentLevel,
      "EmpCD": empCD,
      "CompanyID": companyID,
      "Hold_Till_Datetime": holdTillDatetime,
      "Platform_Type": platformType,
      "Is_Image_Uploaded": isImageUploaded,
      "Image_Count": imageCount,
    };
  }
}