import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/sub_category_master_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticket_sub_category_master_bloc.dart';

import '../../../../core/common/widgets/custom_search_bar.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../widgets/ticketing_my_request_action/my_request_web_app_bar.dart';

class TicketSubCategoryMasterPage extends StatefulWidget {
  const TicketSubCategoryMasterPage({super.key});

  @override
  State<TicketSubCategoryMasterPage> createState() =>
      _TicketSubCategoryMasterPageState();
}

class _TicketSubCategoryMasterPageState
    extends State<TicketSubCategoryMasterPage> {
  List<SubCategoryMasterEntity> subCategories = [];

  List<SubCategoryMasterEntity> filteredSubCategories = [];

  static const List<String> _headers = [
    "Sub-Category Description",
    "Assigned Category",
    "Assigned Priority",
    "Action Status",
  ];

  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();

    _apiCallForSubCategoryList();
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _apiCallForSubCategoryList() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyId = employee.companyId;
      if (companyId != null) {
        context.read<TicketSubCategoryMasterBloc>().add(
          TicketSubCategoryListRequested(companyID: companyId),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        context.pop();
      },
      child: Column(
        children: [
          if (!isMobile) ...[
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
            SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: isMobile ? 408 : 400,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: CustomSearchBar(
                      hintText: 'Search Here ...',
                      onChanged: _searchOperation,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  void _searchOperation(String query) {}
}
