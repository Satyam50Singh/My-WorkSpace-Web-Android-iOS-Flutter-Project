class AddNewTicketRequestModel {
  final int? locationID;
  final int? categoryID;
  final int? subCategoryID;
  final String? ticketMessage;
  final String? empCD;
  final int? companyID;
  final String? platformType;
  final int? isImageUploaded;
  final int? imageCount;
  final int? refNo;

  AddNewTicketRequestModel({
    this.locationID,
    this.categoryID,
    this.subCategoryID,
    this.ticketMessage,
    this.empCD,
    this.companyID,
    this.platformType,
    this.isImageUploaded,
    this.imageCount,
    this.refNo,
  });

  Map<String, dynamic> toJson() {
    return {
      'LocationID': locationID,
      'CategoryID': categoryID,
      'SubCategoryID': subCategoryID,
      'Ticket_Message': ticketMessage,
      'EmpCD': empCD,
      'CompanyID': companyID,
      'Platform_Type': platformType,
      'Is_Image_Uploaded': isImageUploaded,
      'Image_Count': imageCount,
      'Ref_No': refNo,
    };
  }
}
