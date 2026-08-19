import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';

class ViewTicketDetails extends StatefulWidget {
  const ViewTicketDetails({super.key});

  @override
  State<ViewTicketDetails> createState() => _ViewTicketDetailsState();
}

class _ViewTicketDetailsState extends State<ViewTicketDetails> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: 90,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(
                color: AppColors.slate.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton.filled(
                  onPressed: () {
                   context.go('ticket-list');
                  },
                  icon: const Icon(
                    Icons.keyboard_backspace_outlined,
                    color: AppColors.slate,
                  ),
                ),

                Text(
                  'View Ticket Details',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Chip(
                  label: Text('Open', style: TextStyle(color: Colors.white)),
                  backgroundColor: AppColors.rose,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
