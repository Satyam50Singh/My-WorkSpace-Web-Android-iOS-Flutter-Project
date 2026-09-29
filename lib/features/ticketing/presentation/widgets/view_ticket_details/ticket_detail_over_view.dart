import 'package:flutter/material.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_action_details/manage_action_ticket_card.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/classification_location_card.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/requestor_profile_card.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/ticket_images_bottom_card.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/ticket_info_card.dart';

import '../../../domain/entities/view_ticket_detail_entities/view_ticket_detail_v6_entity.dart';
import 'manage_ticket_card.dart';

class TicketDetailOverView extends StatelessWidget {
  final String pageTag;
  final ViewTicketDetailV6Entity? ticketDetails;
  final Function(String remarks, int isReview) onActionSubmit;
  final Function() onTransferTicket;
  final Function() onAcceptTicket;
  final Function() onInProgressTicket;
  final Function() onHoldTicket;
  final Function() onCloseTicket;

  const TicketDetailOverView({
    super.key,
    required this.pageTag,
    required this.ticketDetails,
    required this.onActionSubmit,
    required this.onTransferTicket,
    required this.onAcceptTicket,
    required this.onInProgressTicket,
    required this.onHoldTicket,
    required this.onCloseTicket,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    if (isMobile) {
      return Column(
        children: [
          TicketInfoCard(ticketDetails: ticketDetails),
          ClassificationLocationCard(ticketDetails: ticketDetails),
          RequestorProfileCard(ticketDetails: ticketDetails),
          TicketImagesBottomCard(ticketDetails: ticketDetails),
          const SizedBox(height: 16),
          if (ticketDetails?.isReopenReviewAllowed == true &&
              pageTag.isNotEmpty &&
              pageTag == 'my-request')
            ManageTicketCard(onActionSubmit: onActionSubmit),
          if (pageTag.isNotEmpty &&
              pageTag == 'my-actions' &&
              (ticketDetails?.isAcceptAllowed == true ||
                  ticketDetails?.isActionAllowed == true))
            ManageActionTicketCard(
              isAcceptAllowed: ticketDetails?.isAcceptAllowed ?? false,
              isActionAllowed: ticketDetails?.isActionAllowed ?? false,
              onAcceptTicket: onAcceptTicket,
              onTransferTicket: onTransferTicket,
              onInProgressTicket: onInProgressTicket,
              onHoldTicket: onHoldTicket,
              onCloseTicket: onCloseTicket,
            ),
          const SizedBox(height: 48), // Bottom spacing
        ],
      );
    } else {
      return Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: TicketInfoCard(ticketDetails: ticketDetails)),
                Expanded(
                  child: ClassificationLocationCard(
                    ticketDetails: ticketDetails,
                  ),
                ),
                Expanded(
                  child: RequestorProfileCard(ticketDetails: ticketDetails),
                ),
              ],
            ),
          ),
          TicketImagesBottomCard(ticketDetails: ticketDetails),
          const SizedBox(height: 16),
          if (ticketDetails?.isReopenReviewAllowed == true &&
              pageTag.isNotEmpty &&
              pageTag == 'my-request')
            ManageTicketCard(onActionSubmit: onActionSubmit),
          if (pageTag.isNotEmpty &&
              pageTag == 'my-actions' &&
              (ticketDetails?.isAcceptAllowed == true ||
                  ticketDetails?.isActionAllowed == true))
            ManageActionTicketCard(
              isAcceptAllowed: ticketDetails?.isAcceptAllowed ?? false,
              isActionAllowed: ticketDetails?.isActionAllowed ?? false,
              onAcceptTicket: onAcceptTicket,
              onTransferTicket: onTransferTicket,
              onInProgressTicket: onInProgressTicket,
              onHoldTicket: onHoldTicket,
              onCloseTicket: onCloseTicket,
            ),
          const SizedBox(height: 48), // Bottom spacing
        ],
      );
    }
  }
}
