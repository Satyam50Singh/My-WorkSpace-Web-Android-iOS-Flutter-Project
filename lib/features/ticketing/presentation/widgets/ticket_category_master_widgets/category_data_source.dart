import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';

class CategoryDataSource<T> extends DataTableSource {
  final BuildContext context;
  final List<T> items;
  final int firstRowIndex;
  final List<DataCell> Function(T item, bool isMobile) cellBuilder;

  CategoryDataSource(
    this.context,
    this.items,
    this.firstRowIndex, {
    required this.cellBuilder,
  });

  @override
  DataRow? getRow(int index) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    final relativeIndex = index - firstRowIndex;
    if (relativeIndex < 0 || relativeIndex >= items.length) {
      return null;
    }

    final item = items[relativeIndex];

    return DataRow2(cells: cellBuilder(item, isMobile));
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => items.length;

  @override
  int get selectedRowCount => 0;
}
