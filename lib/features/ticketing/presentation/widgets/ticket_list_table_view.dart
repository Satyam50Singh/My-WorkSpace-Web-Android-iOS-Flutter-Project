import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_detail.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/status_cell.dart';

class TicketListTableView extends StatefulWidget {
  final List<TicketDetailList>? ticketingDetailList;
  final void Function(int) updatePageSize;
  final void Function(int) updatePageCount;
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
  });

  @override
  State<TicketListTableView> createState() => _TicketListTableViewState();
}

class _TicketListTableViewState extends State<TicketListTableView> {
  final List<String> headers = [
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

    debugPrint('tickets: ${tickets.length}');
    debugPrint('rowsPerPage: $effectiveRowsPerPage');

    final availableRows = [10, 25, 50, 100];
    if (effectiveRowsPerPage > 0 &&
        !availableRows.contains(effectiveRowsPerPage)) {
      availableRows.add(effectiveRowsPerPage);
      availableRows.sort();
    }

    return PaginatedDataTable2(
      minWidth: 1600,
      headingRowColor: WidgetStateColor.resolveWith(
        (states) => AppColors.primaryDark,
      ),
      headingRowDecoration: BoxDecoration(
        color: AppColors.primaryDark,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(8),
          topRight: Radius.circular(8),
        ),
      ),
      fixedLeftColumns: 1,
      fixedCornerColor: AppColors.primaryDark,
      columns: headers.map((header) {
        return DataColumn2(
          label: Text(
            header,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 16,
              color: AppColors.white,
              fontWeight: FontWeight.w400,
            ),
          ),
          fixedWidth: header == "Ticket Number"
              ? 120
              : header == "Ticket Date & Time"
              ? 200
              : header == "Level"
              ? 80
              : header == "Location"
              ? 300
              : null,
        );
      }).toList(),
      source: TicketDataSource(
        tickets,
        widget.totalRecordsCount,
        (widget.currentPage - 1) * effectiveRowsPerPage,
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
      empty: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, color: AppColors.slate, size: 48),
              Text(
                'No tickets found matching current filters',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.primaryDark,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
              Text(
                'Try resetting filters or changing tabs',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.slate,
                  fontWeight: FontWeight.w600,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TicketDataSource extends DataTableSource {
  final List<TicketDetailList> tickets;
  final int totalRecordsCount;
  final int firstRowIndex;

  TicketDataSource(this.tickets, this.totalRecordsCount, this.firstRowIndex);

  @override
  DataRow? getRow(int index) {
    final relativeIndex = index - firstRowIndex;
    if (relativeIndex < 0 || relativeIndex >= tickets.length) {
      return null;
    }

    final ticket = tickets[relativeIndex];

    return DataRow2(
      cells: [
        DataCell(
          Text(
            ticket.ticketCode ?? '-',
            style: TextStyle(overflow: TextOverflow.ellipsis),
            softWrap: false,
            maxLines: 1,
          ),
        ),
        DataCell(Text(ticket.level ?? '-')),
        DataCell(
          Text(
            ticket.ticketDate ?? '-',
            style: TextStyle(overflow: TextOverflow.ellipsis),
            softWrap: false,
            maxLines: 1,
          ),
        ),
        DataCell(StatusCell(text: ticket.ticketStatus ?? '-')),
        DataCell(StatusCell(text: ticket.ticketActionStatus ?? '-')),
        DataCell(Text(ticket.raisedByUser ?? '-')),
        DataCell(Text(ticket.ticketType ?? '-')),
        DataCell(
          Text(
            ticket.subCategory ?? '-',
            style: TextStyle(overflow: TextOverflow.ellipsis),
            softWrap: false,
            maxLines: 1,
          ),
        ),
        DataCell(
          Text(
            (ticket.lastActionBy?.isNotEmpty ?? false)
                ? ticket.lastActionBy!
                : '-',
          ),
        ),
        DataCell(
          Text(
            ticket.location ?? '-',
            style: TextStyle(overflow: TextOverflow.ellipsis),
            softWrap: false,
            maxLines: 1,
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => totalRecordsCount;

  @override
  int get selectedRowCount => 0;
}
