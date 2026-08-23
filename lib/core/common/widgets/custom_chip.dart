import 'package:flutter/material.dart';

import '../../utils/ticket_status_utils.dart';

class CustomChip extends StatelessWidget {
  final String status;

  const CustomChip({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: TicketStatusUtils.getStatusBgColor(status),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: TicketStatusUtils.getStatusBorderColor(status),
          width: 1,
        ),
      ),
      child: Text(
        status,
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: TicketStatusUtils.getStatusTextColor(status),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
