import 'package:flutter/material.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_details/ticket_info_card.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/view_ticket_detail_v6.dart';

class TicketDetailOverView extends StatelessWidget {
  final ViewTicketDetailV6Entity? ticketDetails;

  const TicketDetailOverView({super.key, required this.ticketDetails});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            TicketInfoCard(ticketDetails: ticketDetails),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 400),
                  child: Card(
                    elevation: 2,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(ticketDetails!.ticketID.toString()),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 400),
                  child: Card(
                    elevation: 2,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(ticketDetails!.ticketID.toString()),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 400,
                    maxWidth: double.infinity,
                  ),
                  child: Card(
                    elevation: 2,
                    color: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    margin: EdgeInsets.zero,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(ticketDetails!.ticketID.toString()),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
