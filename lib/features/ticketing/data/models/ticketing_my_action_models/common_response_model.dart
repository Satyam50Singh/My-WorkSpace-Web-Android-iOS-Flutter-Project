class CommonResponseModel {
  int? status;
  String? message;

  CommonResponseModel({this.status, this.message});

  factory CommonResponseModel.fromJson(Map<String, dynamic> json) {
    return CommonResponseModel(
      status: json['Status'] as int? ?? 0,
      message: json['Message'] as String? ?? "",
    );
  }
}