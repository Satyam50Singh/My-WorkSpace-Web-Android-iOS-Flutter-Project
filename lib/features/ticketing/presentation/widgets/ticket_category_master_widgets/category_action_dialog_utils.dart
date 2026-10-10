import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/ticket_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/pages/add_new_category_page.dart';

import '../../pages/external_transfer_ticket_page.dart';

class CategoryActionDialogUtils {
  static void showAddNewCategoryDialog({
    required BuildContext buildContext,
    TicketCategoryEntity? selectedCategory,
    VoidCallback? onSuccess,
  }) async {
    final width = MediaQuery.sizeOf(buildContext).width;
    final isTablet = width >= 600 && width < 1200;
    final isMobile = width < 600;

    if (isMobile) {
      final result = await buildContext.pushNamed<bool>(
        'external-transfer-ticket',
        //pathParameters: {'ticketId': '${ticketId ?? 0}'},
      );
      if (result == true) {
        debugPrint('navigated with true');
        onSuccess?.call();
      }
    } else {
      final dialogWidth = isTablet
          ? 440.0
          : isMobile
          ? 360.0
          : 640.0;

      final result = await showDialog<bool>(
        context: buildContext,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            alignment: Alignment.centerRight,
            insetPadding: EdgeInsets.zero,
            child: SizedBox(
              width: dialogWidth,
              height: double.infinity,
              child: AddNewCategoryPage(
                selectedCategory: selectedCategory,
              ),
            ),
          );
        },
      );

      if (result == true) {
        debugPrint('navigated with true');
        onSuccess?.call();
      }
    }
  }
}
