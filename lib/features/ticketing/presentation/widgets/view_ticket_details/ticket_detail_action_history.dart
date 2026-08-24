import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/common/widgets/custom_chip.dart';
import 'package:my_worksphere_web/core/common/widgets/custom_search_bar.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';

import '../../../domain/entities/ticket_history_entity.dart';

class TicketDetailActionHistory extends StatefulWidget {
  final List<TicketHistoryEntity>? actionHistoryList;

  const TicketDetailActionHistory({super.key, required this.actionHistoryList});

  @override
  State<TicketDetailActionHistory> createState() =>
      _TicketDetailActionHistoryState();
}

class _TicketDetailActionHistoryState extends State<TicketDetailActionHistory> {
  List<TicketHistoryEntity>? filteredList = [];

  void filterList(String value) {
    debugPrint('Value: $value');
    setState(() {
      filteredList = widget.actionHistoryList
          ?.where(
            (item) {
              final searchTerm = value.toLowerCase();
              return (item.userName?.toLowerCase().contains(searchTerm) ?? false) ||
                  (item.ticketStatus?.toLowerCase().contains(searchTerm) ?? false) ||
                  (item.ticketActionStatus?.toLowerCase().contains(searchTerm) ?? false);
            },
      )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    if (widget.actionHistoryList == null || widget.actionHistoryList!.isEmpty) {
      return const SizedBox.shrink();
    }

    if (filteredList?.isEmpty == true) {
      filteredList?.addAll(
        widget.actionHistoryList as Iterable<TicketHistoryEntity>,
      );
    }


    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      'Audit Log & State Transition History',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontSize: isMobile ? 16 : 18,
                            fontWeight: FontWeight.bold,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Spacer(),
                  if (!isMobile)
                    Expanded(
                      child: SizedBox(
                        width: 200,
                        child: CustomSearchBar(
                          hintText: 'Search logs, user, action status ...',
                          onChanged: (value) {
                            if (value.length > 1) {
                              filterList(value);
                            } else {
                              setState(() {
                                filteredList = [];
                              });
                            }
                          },
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: isMobile
                      ? 1000
                      : MediaQuery.of(context).size.width - 360,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  // padding: EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColors.primaryDark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                        ),
                        height: 42,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'Level',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'User Name',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'Remarks',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Action Date & Time',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  'Expected Date & Time',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'Ticket Status',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Center(
                                child: Text(
                                  'Action Status',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),

                      ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredList!.length,
                        itemBuilder: (context, index) {
                          final actionHistory = filteredList![index];
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: (isMobile ? 8.0 : 12.0),
                              left: 12,
                              right: 12,
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          'L${actionHistory.level}',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          actionHistory.userName ?? '-',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Center(
                                        child: Text(
                                          actionHistory.remarks ?? '-',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          actionHistory.actionDateTime ?? '-',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Center(
                                        child: Text(
                                          actionHistory.expectedDateTime ?? '-',
                                          style: TextStyle(
                                            color: Colors.black54,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: CustomChip(
                                          status:
                                              actionHistory.ticketStatus ?? '-',
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: CustomChip(
                                          status:
                                              actionHistory
                                                  .ticketActionStatus ??
                                              '-',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return Divider(color: Colors.grey.shade200);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
