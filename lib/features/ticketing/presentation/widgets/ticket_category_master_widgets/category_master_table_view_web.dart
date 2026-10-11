import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/ticket_category_entities/ticket_category_entity.dart';
import '../ticketing_my_request_action/ticket_list_empty_view.dart';
import 'category_data_source.dart';

class CategoryMasterTableViewWeb extends StatefulWidget {
  final List<TicketCategoryEntity> filteredCategories;
  final Function(String, TicketCategoryEntity) performEditDeleteOperation;

  const CategoryMasterTableViewWeb({
    super.key,
    required this.filteredCategories,
    required this.performEditDeleteOperation,
  });

  @override
  State<CategoryMasterTableViewWeb> createState() =>
      _CategoryMasterTableViewWebState();
}

class _CategoryMasterTableViewWebState
    extends State<CategoryMasterTableViewWeb> {
  static const List<String> _headers = [
    "Category Description",
    "Assigned Department",
    "Action Status",
  ];

  DataColumn2 _buildColumnHeaderCell(String header) {
    return DataColumn2(
      label: Center(
        child: Text(
          header,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 14,
            color: AppColors.white,
            fontWeight: FontWeight.w400,
          ),
          softWrap: false,
          maxLines: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return Padding(
      padding: EdgeInsets.only(
        left: 8.0,
        right: 8.0,
        top: isMobile ? 08 : 32,
        bottom: 32,
      ),
      child: PaginatedDataTable2(
        minWidth: 640,
        headingRowColor: WidgetStateColor.resolveWith(
          (states) => AppColors.primaryDark,
        ),
        headingRowDecoration: const BoxDecoration(
          color: AppColors.primaryDark,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
          ),
        ),
        columns: _headers.map((header) {
          return _buildColumnHeaderCell(header);
        }).toList(),
        source: CategoryDataSource(
          context,
          widget.filteredCategories,
          0,
          onActionBtnPressed: (c1, action) {
            widget.performEditDeleteOperation(action, c1);
          },
        ),
        onRowsPerPageChanged: (value) {
          if (value == null) return;
        },
        dataRowHeight: 54,
        empty: const TicketListEmptyView(),
        renderEmptyRowsInTheEnd: false,
      ),
    );
  }
}
