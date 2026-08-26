part of 'view_ticket_details_bloc.dart';

abstract class ViewTicketDetailsState {}

final class ViewTicketDetailsInitial extends ViewTicketDetailsState {}

final class ViewTicketDetailsLoading extends ViewTicketDetailsState {}

final class ViewTicketDetailsFailure extends ViewTicketDetailsState {
  final String errorMessage;

  ViewTicketDetailsFailure(this.errorMessage);
}

final class ViewTicketDetailsV6Success extends ViewTicketDetailsState {
  final List<ViewTicketDetailV6Entity> viewTicketDetailV6;

  ViewTicketDetailsV6Success(this.viewTicketDetailV6);
}

final class ViewTicketWorkflowDetailsSuccess extends ViewTicketDetailsState {
  final List<TicketWorkflowEntity> ticketWorkflow;

  ViewTicketWorkflowDetailsSuccess(this.ticketWorkflow);
}

final class ViewTicketActionHistorySuccess extends ViewTicketDetailsState {
  final List<TicketHistoryEntity> ticketHistory;

  ViewTicketActionHistorySuccess(this.ticketHistory);
}

final class SubmitReopenReviewSuccess extends ViewTicketDetailsState {
  final SubmitReopenReviewEntity submitReopenReviewEntity;

  SubmitReopenReviewSuccess(this.submitReopenReviewEntity);
}
