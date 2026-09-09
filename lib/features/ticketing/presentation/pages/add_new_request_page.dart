import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_worksphere_web/core/common/widgets/custom_drop_down.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/add_new_request_bloc/add_new_ticket_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/add_new_request_header.dart';

import '../../data/models/add_new_request/ticket_location_category_request.dart';

class AddNewRequestPage extends StatefulWidget {
  const AddNewRequestPage({super.key});

  @override
  State<AddNewRequestPage> createState() => _AddNewRequestPageState();
}

class _AddNewRequestPageState extends State<AddNewRequestPage> {
  @override
  void initState() {
    super.initState();
    // fetch Fetch_Ticket_Location_Category_V2
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final payload = TicketLocationCategoryRequest(
        companyId: state.employeeDetail.companyId ?? 0,
        empCd: state.employeeDetail.empCd ?? '',
        retailerId: 0,
      );
      context.read<AddNewTicketBloc>().add(
        FetchTicketLocationCategoryRequested(payload),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AddNewRequestHeader(),

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<AddNewTicketBloc, AddNewTicketState>(
            builder: (context, state) {
              if (state is TicketLocationCategorySuccess) {
                final allLocation = state.data.locationDetails![0].allLocation;

                return Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.location_on_outlined,
                                  size: 16,
                                  color: AppColors.primary,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Location',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  '*',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.rose),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),
                            CustomDropDown(
                              items: allLocation ?? [],
                              onSelected: (selectedLocationId) {
                                debugPrint('selectedLocationId: $selectedLocationId');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return SizedBox.shrink();
            },
            listener: (context, state) {
              if (state is AddNewTicketLoading) {
                LoaderUtils.showLoader(context);
              }
              if (state is TicketLocationCategorySuccess) {
                LoaderUtils.hideLoader(context);
              }
              if (state is AddNewTicketFailure) {
                SnackBarUtils.showFloatingSnackBar(context, state.errorMessage);
                LoaderUtils.hideLoader(context);
              }
            },
          ),
        ),
      ],
    );
  }
}
