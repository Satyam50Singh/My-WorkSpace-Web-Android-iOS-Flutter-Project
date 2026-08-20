import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/view_ticket_details/view_ticket_detail_request.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/view_ticket_detail_v6.dart';

import '../../../domain/entities/ticket_history_entity.dart';
import '../../../domain/entities/ticket_workflow_entity.dart';

part 'view_ticket_details_event.dart';
part 'view_ticket_details_state.dart';

class ViewTicketDetailsBloc extends Bloc<ViewTicketDetailsEvent, ViewTicketDetailsState> {
  ViewTicketDetailsBloc() : super(ViewTicketDetailsInitial()) {
    on<ViewTicketDetailsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
