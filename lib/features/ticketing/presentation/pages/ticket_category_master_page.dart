import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';

import '../blocs/ticket_category_master_bloc/ticket_category_master_bloc.dart';
import '../widgets/ticketing_my_request_action/my_request_web_app_bar.dart';

class TicketCategoryMasterPage extends StatefulWidget {
  const TicketCategoryMasterPage({super.key});

  @override
  State<TicketCategoryMasterPage> createState() =>
      _TicketCategoryMasterPageState();
}

class _TicketCategoryMasterPageState extends State<TicketCategoryMasterPage> {
  @override
  void initState() {
    super.initState();

    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyId = employee.companyId;
      if (companyId != null) {
        context.read<TicketCategoryMasterBloc>().add(
          TicketCategoryListRequested(companyID: companyId),
        );
      }
    }
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
            title: 'Ticket Categories',
            showAddNewBtn: true,
            showExportToExcelBtn: true,
            addNewBtnTitleText: 'Add New Category',
            onTapExportToExcel: () {
              // TODO: Export to Excel
            },
            onTapAddNewRequest: () {
              // TODO: Add New Request
            },
          ),

          BlocConsumer<TicketCategoryMasterBloc, TicketCategoryMasterState>(
            listener: (context, state) {
              if (state is TicketCategoryMasterLoading) {
                LoaderUtils.showLoader(context);
              }
              if (state is TicketCategoryMasterFailure) {
                LoaderUtils.hideLoader(context);
                SnackBarUtils.showFloatingSnackBar(context, state.errorMessage);
              }
              if (state is TicketCategoryMasterSuccess) {
                LoaderUtils.hideLoader(context);
              }
            },
            builder: (context, state) {
              return Column(children: [

              ]);
            },
          ),
        ],
      ),
    );
  }
}
