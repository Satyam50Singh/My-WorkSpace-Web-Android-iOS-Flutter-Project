import 'package:flutter/material.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/classification_location_card.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/requestor_profile_card.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/ticket_images_bottom_card.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/ticket_info_card.dart';

import '../../../domain/entities/view_ticket_detail_v6.dart';

class TicketDetailOverView extends StatelessWidget {
  final ViewTicketDetailV6Entity? ticketDetails;

  const TicketDetailOverView({super.key, required this.ticketDetails});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    if (isMobile) {
      return Column(
        children: [
          TicketInfoCard(ticketDetails: ticketDetails),
          ClassificationLocationCard(ticketDetails: ticketDetails),
          RequestorProfileCard(ticketDetails: ticketDetails),
          TicketImagesBottomCard(ticketDetails: ticketDetails),
          const SizedBox(height: 24), // Bottom spacing to avoid overlay issues
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: TicketInfoCard(ticketDetails: ticketDetails)),
              Expanded(
                child: ClassificationLocationCard(ticketDetails: ticketDetails),
              ),
              Expanded(child: RequestorProfileCard(ticketDetails: ticketDetails)),
            ],
          ),
          TicketImagesBottomCard(ticketDetails: ticketDetails),
          const SizedBox(height: 24), // Bottom spacing
        ],
      );
    }
  }


}
