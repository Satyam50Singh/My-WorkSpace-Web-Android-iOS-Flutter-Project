import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../ticketing_my_request_action/ticket_list_empty_view.dart';
import 'category_data_source.dart';

class CategoryMasterTableViewWeb<T> extends StatefulWidget {
  final List<T> filteredItems;
  final List<String> headers;
  final List<DataCell> Function(T item, bool isMobile) cellBuilder;
  final double minWidth;

  const CategoryMasterTableViewWeb({
    super.key,
    required this.filteredItems,
    required this.headers,
    required this.cellBuilder,
    this.minWidth = 640,
  });

  @override
  State<CategoryMasterTableViewWeb<T>> createState() =>
      _CategoryMasterTableViewWebState<T>();
}

class _CategoryMasterTableViewWebState<T>
    extends State<CategoryMasterTableViewWeb<T>> {
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
        columns: widget.headers.map((header) {
          return _buildColumnHeaderCell(header);
        }).toList(),
        source: CategoryDataSource<T>(
          context,
          widget.filteredItems,
          0,
          cellBuilder: (item, isMobile) => widget.cellBuilder(item, isMobile),
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
