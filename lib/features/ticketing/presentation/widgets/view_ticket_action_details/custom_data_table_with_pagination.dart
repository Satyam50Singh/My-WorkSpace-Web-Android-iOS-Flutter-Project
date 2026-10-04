import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/ticketing_my_action_entities/ticket_transfer_user_list_entity.dart';

class CustomDataTableWithPagination extends StatefulWidget {
  final List<TicketTransferUserListEntity> userList;
  final ValueChanged<String> onUserSelected;

  const CustomDataTableWithPagination({
    super.key,
    required this.userList,
    required this.onUserSelected,
  });

  @override
  State<CustomDataTableWithPagination> createState() =>
      _CustomDataTableWithPaginationState();
}

class _CustomDataTableWithPaginationState
    extends State<CustomDataTableWithPagination> {
  String? _selectedUserCode;

  final List<TicketTransferUserListEntity> filteredList = [];

  int totalPages = 0;
  int selectedPage = 1;

  @override
  void initState() {
    super.initState();

    totalPages = (widget.userList.length / 5).ceil();

    final endIndex = widget.userList.length > 5 ? 5 : widget.userList.length;
    filteredList.addAll(widget.userList.sublist(0, endIndex));

    debugPrint(filteredList[0].toString());
  }

  @override
  void didUpdateWidget(covariant CustomDataTableWithPagination oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.userList != widget.userList) {
      totalPages = (widget.userList.length / 5).ceil();
      selectedPage = 1;

      final endIndex = widget.userList.length > 5 ? 5 : widget.userList.length;

      filteredList
        ..clear()
        ..addAll(widget.userList.sublist(0, endIndex));

      _selectedUserCode = null;
    }
  }

  void goToPreviousPage() {
    if (selectedPage > 1) {
      changePage(selectedPage - 1);
    }
  }

  void goToNextPage() {
    if (selectedPage < totalPages) {
      changePage(selectedPage + 1);
    }
  }

  void changePage(int page) {
    final startIndex = (page - 1) * 5;
    final endIndex = min(startIndex + 5, widget.userList.length);

    setState(() {
      filteredList
        ..clear()
        ..addAll(widget.userList.sublist(startIndex, endIndex));

      selectedPage = page;
    });
  }

  Widget _buildColumnHeaderCell(String title, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Text(
          title.toUpperCase(),
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final startEntry = widget.userList.isEmpty
        ? 0
        : ((selectedPage - 1) * 5) + 1;

    final endEntry = min(selectedPage * 5, widget.userList.length);

    return Column(
      children: [
        SizedBox(
          height: 264,
          child: Card(
            elevation: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    border: Border(
                      bottom: BorderSide(color: AppColors.border, width: 1),
                    ),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        width: 60,
                        child: Text(
                          'SELECT',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      _buildColumnHeaderCell('User Name', flex: 2),
                      _buildColumnHeaderCell('User Code', flex: 2),
                      _buildColumnHeaderCell('Department', flex: 3),
                    ],
                  ),
                ),
                Expanded(
                  child: RadioGroup<String>(
                    groupValue: _selectedUserCode,
                    onChanged: (value) {
                      setState(() {
                        _selectedUserCode = value;
                        widget.onUserSelected(_selectedUserCode ?? '');
                      });
                    },
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (context, index) {
                        final user = filteredList[index];
                        final String userCode = user.userID.toString();
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 60,
                              child: Radio<String>(value: userCode),
                            ),
                            _buildColumnHeaderCell(
                              user.userName ?? '-',
                              flex: 2,
                            ),
                            _buildColumnHeaderCell(
                              user.userCode ?? '-',
                              flex: 2,
                            ),
                            _buildColumnHeaderCell(
                              user.department ?? '-',
                              flex: 3,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        if (filteredList.length > 1)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    'Showing $startEntry to $endEntry of ${widget.userList.length} entries',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                    maxLines: 2,
                  ),
                ),
                Row(
                  children: [
                    IconButton.filled(
                      onPressed: goToPreviousPage,
                      icon: Icon(Icons.navigate_before),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: AppColors.textHint,
                      ),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Page $selectedPage of $totalPages',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(width: 8),
                    IconButton.filled(
                      onPressed: goToNextPage,
                      icon: Icon(Icons.navigate_next_outlined),
                      style: IconButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        backgroundColor: AppColors.textHint,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }
}
