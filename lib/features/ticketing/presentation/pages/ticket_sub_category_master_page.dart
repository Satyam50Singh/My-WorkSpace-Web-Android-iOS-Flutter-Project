import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/ticketing_my_request_action/my_request_web_app_bar.dart';

class TicketSubCategoryMasterPage extends StatefulWidget {
  const TicketSubCategoryMasterPage({super.key});

  @override
  State<TicketSubCategoryMasterPage> createState() =>
      _TicketSubCategoryMasterPageState();
}

class _TicketSubCategoryMasterPageState
    extends State<TicketSubCategoryMasterPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.pop();
      },
      child: Column(
        children: [
          TicketingMyRequestWebAppBar(
            title: 'Ticket Sub-Categories',
            showAddNewBtn: true,
            showExportToExcelBtn: true,
            addNewBtnTitleText: 'Add New Sub-Category',
            onTapExportToExcel: () {
              // TODO: Export to Excel
            },
            onTapAddNewRequest: () {
              // TODO: Add New Request
            },
          ),

        ],
      ),
    );
  }
}
