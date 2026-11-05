import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/common/widgets/ticket_list_empty_view.dart';

import '../../theme/app_colors.dart';
import 'custom_master_data_source.dart';

class CustomMasterTableViewWeb<T> extends StatefulWidget {
  final List<T> filteredItems;
  final List<String> headers;
  final List<DataCell> Function(T item, bool isMobile) cellBuilder;
  final double minWidth;
  final double? Function(String header)? columnWidthBuilder;

  const CustomMasterTableViewWeb({
    super.key,
    required this.filteredItems,
    required this.headers,
    required this.cellBuilder,
    this.minWidth = 640,
    this.columnWidthBuilder,
  });

  @override
  State<CustomMasterTableViewWeb<T>> createState() =>
      _CustomMasterTableViewWebState<T>();
}

class _CustomMasterTableViewWebState<T>
    extends State<CustomMasterTableViewWeb<T>> {
  DataColumn2 _buildColumnHeaderCell(String header) {
    final fixedWidth = widget.columnWidthBuilder?.call(header);
    return DataColumn2(
      size: ColumnSize.M,
      fixedWidth: fixedWidth,
      label: Center(
        child: Text(
          header,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 14,
            color: AppColors.white,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PaginatedDataTable2(
      minWidth: widget.minWidth,
      fixedCornerColor: AppColors.primaryDark,
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
      source: CustomMasterDataSource<T>(
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
    );
  }
}
