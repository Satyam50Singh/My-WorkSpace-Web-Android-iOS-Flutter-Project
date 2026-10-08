import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/ticket_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_category_master_widgets/category_action_button.dart';

import '../../../../../core/theme/app_colors.dart';

class CategoryDataSource extends DataTableSource {
  final BuildContext context;
  final List<TicketCategoryEntity> categories;
  final int firstRowIndex;
  final void Function(String) onTap;

  CategoryDataSource(
    this.context,
    this.categories,
    this.firstRowIndex, {
    required this.onTap,
  });

  Widget _buildCell(String text, bool isMobile, {Color? color}) {
    return isMobile
        ? Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 14,
              color: color ?? AppColors.textPrimary,
            ),
          )
        : Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: 14,
                color: color ?? AppColors.textPrimary,
              ),
            ),
          );
  }

  @override
  DataRow? getRow(int index) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;

    final relativeIndex = index - firstRowIndex;
    if (relativeIndex < 0 || relativeIndex >= categories.length) {
      return null;
    }

    final c1 = categories[relativeIndex];

    return DataRow2(
      cells: [
        DataCell(_buildCell(c1.category ?? '-', isMobile)),
        DataCell(
          _buildCell(
            c1.department ?? '-',
            isMobile,
            color: AppColors.textSecondary,
          ),
        ),
        DataCell(
          Row(
            crossAxisAlignment: isMobile
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.center,
            mainAxisAlignment: isMobile
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              CategoryActionButton(
                btnTitle: 'Edit',
                btnColor: AppColors.primary,
                btnTextColor: AppColors.white,
                icon: Icons.edit,
                onPressed: () {},
              ),
              SizedBox(width: 8),
              CategoryActionButton(
                btnTitle: 'Delete',
                btnColor: AppColors.rose,
                btnTextColor: AppColors.white,
                icon: Icons.delete,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => categories.length;

  @override
  int get selectedRowCount => 0;
}
