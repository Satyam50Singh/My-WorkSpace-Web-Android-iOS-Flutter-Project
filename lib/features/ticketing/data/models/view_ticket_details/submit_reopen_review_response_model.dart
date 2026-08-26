class SubmitReopenReviewResponseModel {
  final int? status;
  final String? message;

  SubmitReopenReviewResponseModel(this.status, this.message);

  factory SubmitReopenReviewResponseModel.fromJson(Map<String, dynamic> json) =>
      SubmitReopenReviewResponseModel(json["Status"] as int?, json["Message"] as String?);
}
