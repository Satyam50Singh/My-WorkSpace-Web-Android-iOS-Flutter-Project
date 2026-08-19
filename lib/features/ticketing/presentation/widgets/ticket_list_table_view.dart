import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_detail.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_data_source.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_list_empty_view.dart';

class TicketListTableView extends StatefulWidget {
  final List<TicketDetailList>? ticketingDetailList;
  final void Function(int) updatePageSize;
  final void Function(int) updatePageCount;
  final void Function(String) onTapViewTicketDetail;
  final int rowsPerPage;
  final int totalRecordsCount;
  final int currentPage;

  const TicketListTableView({
    super.key,
    this.ticketingDetailList,
    required this.updatePageSize,
    required this.updatePageCount,
    required this.rowsPerPage,
    required this.totalRecordsCount,
    required this.currentPage,
    required this.onTapViewTicketDetail,
  });

  @override
  State<TicketListTableView> createState() => _TicketListTableViewState();
}

class _TicketListTableViewState extends State<TicketListTableView> {
  static const List<String> _headers = [
    "Ticket Number",
    "Level",
    "Ticket Date & Time",
    "Request Status",
    "Action Status",
    "Raised By",
    "Ticket Type",
    "Sub Category",
    "Lastest Action By",
    "Location",
  ];

  @override
  Widget build(BuildContext context) {
    final tickets = widget.ticketingDetailList ?? [];
    final effectiveRowsPerPage = widget.rowsPerPage > 0
        ? widget.rowsPerPage
        : 10;

    final availableRows = _getAvailableRows(effectiveRowsPerPage);

    return PaginatedDataTable2(
      minWidth: 1600,
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
      fixedLeftColumns: 1,
      fixedCornerColor: AppColors.primaryDark,
      columns: _buildColumns(context),
      source: TicketDataSource(
        context,
        tickets,
        widget.totalRecordsCount,
        (widget.currentPage - 1) * effectiveRowsPerPage,
        onTap: (selectedTicketId) {
          widget.onTapViewTicketDetail(selectedTicketId);
        },
      ),
      initialFirstRowIndex: (widget.currentPage - 1) * effectiveRowsPerPage,
      onRowsPerPageChanged: (value) {
        if (value == null) return;
        widget.updatePageSize(value);
      },
      horizontalMargin: 16,
      columnSpacing: 16,
      headingRowHeight: 48,
      dataRowHeight: 56,
      rowsPerPage: effectiveRowsPerPage,
      availableRowsPerPage: availableRows,
      onPageChanged: (value) {
        final pageIndex = (value / effectiveRowsPerPage).floor() + 1;
        widget.updatePageCount(pageIndex);
      },
      empty: const TicketListEmptyView(),
    );
  }

  List<int> _getAvailableRows(int effectiveRowsPerPage) {
    final availableRows = [10, 25, 50, 100];
    if (effectiveRowsPerPage > 0 &&
        !availableRows.contains(effectiveRowsPerPage)) {
      availableRows.add(effectiveRowsPerPage);
      availableRows.sort();
    }
    return availableRows;
  }

  List<DataColumn2> _buildColumns(BuildContext context) {
    return _headers.map((header) {
      return DataColumn2(
        label: Text(
          header,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 16,
            color: AppColors.white,
            fontWeight: FontWeight.w400,
          ),
        ),
        fixedWidth: _getColumnWidth(header),
      );
    }).toList();
  }

  double? _getColumnWidth(String header) {
    switch (header) {
      case "Ticket Number":
        return 120;
      case "Ticket Date & Time":
        return 200;
      case "Level":
        return 80;
      case "Location":
        return 300;
      default:
        return null;
    }
  }
}
