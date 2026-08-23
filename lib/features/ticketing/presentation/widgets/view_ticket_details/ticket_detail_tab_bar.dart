import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class TicketDetailTabBar extends StatefulWidget {
  final void Function(String) onSelectedTab;

  const TicketDetailTabBar({super.key, required this.onSelectedTab});

  @override
  State<TicketDetailTabBar> createState() => _TicketDetailTabBarState();
}

class _TicketDetailTabBarState extends State<TicketDetailTabBar> {
  String selectedTab = 'Ticket Details';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: 160, maxWidth: double.infinity),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTab == 'Ticket Details'
                          ? AppColors.primaryDark
                          : AppColors.white,
                    ),
                    label: Text(
                      'Ticket Details',
                      style: TextStyle(
                        color: selectedTab == 'Ticket Details'
                            ? AppColors.white
                            : AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(
                      Icons.confirmation_number_outlined,
                      color: selectedTab == 'Ticket Details'
                          ? AppColors.white
                          : AppColors.primaryDark,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedTab = 'Ticket Details';
                      });
                      widget.onSelectedTab('Ticket Details');
                    },
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTab == 'Workflow'
                          ? AppColors.primaryDark
                          : AppColors.white,
                    ),
                    label: Text(
                      'Workflow',
                      style: TextStyle(
                        color: selectedTab == 'Workflow'
                            ? AppColors.white
                            : AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(
                      Icons.layers_outlined,
                      color: selectedTab == 'Workflow'
                          ? AppColors.white
                          : AppColors.primaryDark,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedTab = 'Workflow';
                      });
                      widget.onSelectedTab('Workflow');
                    },
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: selectedTab == 'Action History'
                          ? AppColors.primaryDark
                          : AppColors.white,
                    ),
                    label: Text(
                      'Action History',
                      style: TextStyle(
                        color: selectedTab == 'Action History'
                            ? AppColors.white
                            : AppColors.primaryDark,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    icon: Icon(
                      Icons.history,
                      color: selectedTab == 'Action History'
                          ? AppColors.white
                          : AppColors.primaryDark,
                    ),
                    onPressed: () {
                      setState(() {
                        selectedTab = 'Action History';
                      });
                      widget.onSelectedTab('Action History');
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
