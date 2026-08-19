import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/routes/app_routes.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';

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
      children: [
        Container(
          height: 70,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: AppColors.slate.withOpacity(0.2),
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton.filled(
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.slate.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    context.go(AppRoutes.myTickets);
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: AppColors.slate,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'View Ticket Details',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.primaryDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Ticket ID: ${widget.ticketId}',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.slate,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Chip(
                  label: const Text(
                    'Open',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: AppColors.rose,
                  padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                  visualDensity: VisualDensity.compact,
                  side: BorderSide.none,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
