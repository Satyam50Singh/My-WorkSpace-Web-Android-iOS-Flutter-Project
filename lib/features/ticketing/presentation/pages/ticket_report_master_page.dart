import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_report_models/fetch_ticket_report_web_request_model.dart';

import '../../../../core/common/widgets/custom_search_bar.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../../domain/entities/ticket_report_entities/fetch_ticket_report_web_entity.dart';
import '../blocs/ticket_report_master_bloc/ticket_report_master_bloc.dart';
import '../widgets/ticketing_my_request_action/my_request_web_app_bar.dart';

class TicketReportMasterPage extends StatefulWidget {
  const TicketReportMasterPage({super.key});

  @override
  State<TicketReportMasterPage> createState() => _TicketReportMasterPageState();
}

class _TicketReportMasterPageState extends State<TicketReportMasterPage> {
  late final TextEditingController? _searchController;
  TicketReportStatusCountEntity? _ticketReportStatusCount;

  @override
  void initState() {
    _searchController = TextEditingController();

    apiCallForFetchCatSubCatLocDeptTypeList();
    apiCallForFetchTicketReportWeb();

    super.initState();
  }

  void apiCallForFetchCatSubCatLocDeptTypeList() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyID = employee.companyId ?? 0;
      context.read<TicketReportMasterBloc>().add(
        FetchCatSubCatLocDeptTypeListRequested(companyID: companyID),
      );
    }
  }

  void apiCallForFetchTicketReportWeb() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyID = employee.companyId ?? 0;

      final payload = FetchTicketReportWebRequestModel(companyID: companyID);

      context.read<TicketReportMasterBloc>().add(
        FetchTicketReportWebRequested(payload: payload),
      );
    }
  }

  @override
  void dispose() {
    _searchController?.dispose();
    super.dispose();
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
              title: 'Ticket Report',
              showAddNewBtn: false,
              showExportToExcelBtn: true,
              addNewBtnTitleText: '',
              onTapExportToExcel: () {},
              onTapAddNewRequest: () {},
            ),
            SizedBox(height: 8),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 400,
                    child: CustomSearchBar(
                      searchController: _searchController,
                      hintText: 'Search Here ...',
                      onChanged: _searchOperation,
                    ),
                  ),
                  const SizedBox(width: 4),
                  ElevatedButton.icon(
                    onPressed: () {},
                    label: Text('Reset'),
                    icon: Icon(Icons.refresh, size: 16, color: AppColors.white),
                  ),
                ],
              ),
            ),
          ],

          BlocConsumer<TicketReportMasterBloc, TicketReportMasterState>(
            builder: (context, state) {
              return Column(
                children: [if (_ticketReportStatusCount != null) ...[]],
              );
            },
            listener: (context, state) {
              if (state is TicketReportMasterLoading) {
                LoaderUtils.showLoader(context);
              } else if (state is FetchCatSubCatLocDeptTypeListFailure) {
                LoaderUtils.hideLoader(context);
                SnackBarUtils.showFloatingSnackBar(context, state.errorMessage);
              } else if (state is FetchCatSubCatLocDeptTypeListSuccess) {
                LoaderUtils.hideLoader(context);
                debugPrint('FetchCatSubCatLocDeptTypeListSuccess');
              } else if (state is FetchTicketReportWebFailure) {
                LoaderUtils.hideLoader(context);
                SnackBarUtils.showFloatingSnackBar(context, state.errorMessage);
              } else if (state is FetchTicketReportWebSuccess) {
                LoaderUtils.hideLoader(context);
                _ticketReportStatusCount = state.data?.statusCount!.first;
                debugPrint(
                  '_ticketReportStatusCount: ${_ticketReportStatusCount}',
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

void _searchOperation(String query) {}
