import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_detail.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/status_cell.dart';

class TicketListTableView extends StatefulWidget {
  final List<TicketDetailList>? ticketingDetailList;
  final void Function(int) updatePageSize;
  final void Function(int) updatePageCount;
  final int totalRecordsCount;

  const TicketListTableView({
    super.key,
    this.ticketingDetailList,
    required this.updatePageSize,
    required this.updatePageCount,
    required this.totalRecordsCount,
  });

  @override
  State<TicketListTableView> createState() => _TicketListTableViewState();
}

class _TicketListTableViewState extends State<TicketListTableView> {
  final List<String> headers = [
    "Ticket Code",
    "Level",
    "Ticket Date",
    "Ticket Status",
    "Action Status",
    "Raised By User",
    "Ticket Type",
    "Is Review Done",
    "Category",
    "Sub Category",
    "Last Action By",
    "Location",
  ];
  int rowsPerPage = 10;

  @override
  Widget build(BuildContext context) {
    final tickets = widget.ticketingDetailList ?? [];
    debugPrint('tickets: ${tickets.length}');

    return PaginatedDataTable2(
      minWidth: 1800,
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
        );
      }).toList(),
      source: TicketDataSource(tickets, widget.totalRecordsCount),
      onRowsPerPageChanged: (value) {
        if (value == null) return;

        setState(() {
          rowsPerPage = value;
        });

        widget.updatePageSize(value);
      },
      horizontalMargin: 16,
      columnSpacing: 16,
      headingRowHeight: 48,
      dataRowHeight: 56,
      rowsPerPage: rowsPerPage,
      availableRowsPerPage: const [10, 25, 50, 100],
      onPageChanged: (value) {
        debugPrint('onPageChanged: $value');
        widget.updatePageCount(value);
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

  TicketDataSource(this.tickets, this.totalRecordsCount);

  @override
  DataRow? getRow(int index) {
    if (index >= tickets.length) {
      return null;
    }

    final ticket = tickets[index];

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
        DataCell(Text(ticket.isReviewDone == true ? 'Yes' : 'No')),
        DataCell(Text(ticket.category ?? '-')),
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
