import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/ticket_detail.dart';
import 'status_cell.dart';

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
            style: const TextStyle(overflow: TextOverflow.ellipsis),
            softWrap: false,
            maxLines: 1,
          ),
        ),
        DataCell(Text(ticket.level ?? '-')),
        DataCell(
          Text(
            ticket.ticketDate ?? '-',
            style: const TextStyle(overflow: TextOverflow.ellipsis),
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
            style: const TextStyle(overflow: TextOverflow.ellipsis),
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
            style: const TextStyle(overflow: TextOverflow.ellipsis),
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
