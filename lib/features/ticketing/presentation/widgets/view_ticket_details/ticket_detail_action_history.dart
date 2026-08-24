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
      filteredList = widget.actionHistoryList?.where((item) {
        final searchTerm = value.toLowerCase();
        return (item.userName?.toLowerCase().contains(searchTerm) ?? false) ||
            (item.ticketStatus?.toLowerCase().contains(searchTerm) ?? false) ||
            (item.ticketActionStatus?.toLowerCase().contains(searchTerm) ??
                false);
      }).toList();
    });
  }

  Widget _buildHeaderCell(String title, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildContentCell(String title, {required int flex}) {
    return Expanded(
      flex: flex,
      child: Center(
        child: Text(
          title,
          style: TextStyle(color: Colors.black54, fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
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
                            _buildHeaderCell('Level', flex: 1),
                            _buildHeaderCell('User Name', flex: 1),
                            _buildHeaderCell('Remarks', flex: 1),
                            _buildHeaderCell('Action Date & Time', flex: 2),
                            _buildHeaderCell('Expected Date & Time', flex: 2),
                            _buildHeaderCell('Ticket Status', flex: 1),
                            _buildHeaderCell('Action Status', flex: 1),
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
                                    _buildContentCell(
                                      'L${actionHistory.level}',
                                      flex: 1,
                                    ),
                                    _buildContentCell(
                                      actionHistory.userName ?? '-',
                                      flex: 1,
                                    ),
                                    _buildContentCell(
                                      actionHistory.remarks ?? '-',
                                      flex: 1,
                                    ),
                                    _buildContentCell(
                                      actionHistory.actionDateTime ?? '-',
                                      flex: 2,
                                    ),
                                    _buildContentCell(
                                      actionHistory.expectedDateTime ?? '-',
                                      flex: 2,
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
