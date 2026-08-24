import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class TicketCountCard extends StatelessWidget {
  final String title;
  final int count;
  final String selectedStatus;

  const TicketCountCard({
    super.key,
    required this.title,
    required this.count,
    required this.selectedStatus,
  });

  Color _getColorCode(String title) {
    switch (title) {
      case 'All':
        return AppColors.primaryDark;
      case 'Open':
        return AppColors.rose;
      case 'Assigned':
        return AppColors.cyan;
      case 'Accepted':
        return Colors.teal.shade300;
      case 'In Progress':
        return AppColors.amber;
      case 'On Hold':
        return AppColors.secondary;
      case 'Closed':
        return AppColors.error;
      case 'Expired':
        return AppColors.slate;
      case 'Transferred':
        return AppColors.violet;
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color statusColor = _getColorCode(title);

    final width = MediaQuery.sizeOf(context).width;

    final isMini = width < 360;
    final isMobile = width < 600;

    return Container(
      width: isMini || isMobile ? 140 : 150,
      decoration: BoxDecoration(
        color: (selectedStatus == title)
            ? _getColorCode(title).withOpacity(0.2)
            : AppColors.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
        border: Border.all(width: 1, color: statusColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
            ),
            width: 6,
            height: double.infinity,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: isMini || isMobile ? 14 : 16,
                    fontWeight: FontWeight.bold,
                    color: statusColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  count.toString(),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            alignment: Alignment.topRight,
            decoration: BoxDecoration(
              color: statusColor,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
              ),
            ),
            width: 20,
            height: 15,
          ),
        ],
      ),
    );
  }
}
