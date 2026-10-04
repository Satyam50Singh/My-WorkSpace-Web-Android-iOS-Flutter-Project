import 'package:my_worksphere_web/features/ticketing/domain/entities/ticketing_my_action_entities/ticket_transfer_user_list_entity.dart';

class TicketTransferUserListResponseModel {
  int? status;
  String? message;
  List<TransferUserModel>? userList;

  TicketTransferUserListResponseModel({
    this.status,
    this.message,
    this.userList,
  });

  factory TicketTransferUserListResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TicketTransferUserListResponseModel(
      status: json['Status'] as int? ?? 0,
      message: json['Message'] as String? ?? "",
      userList: json['UserList'] != null
          ? (json['UserList'] as List)
                .map((i) => TransferUserModel.fromJson(i as Map<String, dynamic>))
                .toList()
          : null,
    );
  }

}

class TransferUserModel extends TicketTransferUserListEntity {
  TransferUserModel(super.userID, super.userName, super.userCode, super.department);

  TransferUserModel.fromJson(Map<String, dynamic> json)
    : super(
        json['UserID'] as int?,
        json['User_Name'] as String?,
        json['User_Code'] as String?,
        json['Department'] as String?,
      );

  TicketTransferUserListEntity toEntity() {
    return TicketTransferUserListEntity(userID, userName, userCode, department);
  }
}
