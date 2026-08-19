import 'package:flutter/material.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/view_ticket_detail_header.dart';

class ViewTicketDetails extends StatefulWidget {
  final String ticketId;

  const ViewTicketDetails({super.key, required this.ticketId});

  @override
  State<ViewTicketDetails> createState() => _ViewTicketDetailsState();
}

class _ViewTicketDetailsState extends State<ViewTicketDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [ViewTicketDetailHeader(ticketId: widget.ticketId)],
    );
  }
}
