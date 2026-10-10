import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_worksphere_web/core/common/widgets/custom_drop_down.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticketing_my_action_models/transfer_to_other_workflow_request_body.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_location_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_sub_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_workflow_details_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/add_new_request_bloc/add_new_ticket_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticketing_my_action_bloc/ticketing_my_action_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/add_new_request_header.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/label_heading.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/workflow_details_section.dart';

import '../../data/models/add_new_request/ticket_location_category_request.dart';

class ExternalTransferTicketPage extends StatefulWidget {
  final int? ticketId;

  const ExternalTransferTicketPage({
    super.key,
    this.ticketId,
  });

  @override
  State<ExternalTransferTicketPage> createState() =>
      _ExternalTransferTicketPageState();
}

class _ExternalTransferTicketPageState
    extends State<ExternalTransferTicketPage> {
  late final TextEditingController _descriptionController;
  final _formKey = GlobalKey<FormState>();
  List<SubCategoryEntity>? subCategories;
  TicketLocationCategoryEntity? _locationCategoryData;
  List<AddNewTicketWorkFlowEntity> workFlowList = [];

  CategoryEntity? _selectedCategory;
  SubCategoryEntity? _selectedSubCategory;
  bool isSaveBtnEnabled = false;

  @override
  void initState() {
    super.initState();

    _descriptionController = TextEditingController();

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
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AddNewRequestHeader(
              headingText: 'Transfer Ticket',
              btnText: 'Submit',
              onSaveTap: _transferTicket,
              isSaveEnabled: isSaveBtnEnabled,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: BlocListener<TicketingMyActionBloc, TicketingMyActionState>(
                  listener: (context, state) {
                    if (state is TicketingMyActionLoading) {
                      LoaderUtils.showLoader(context);
                    } else if (state is TransferToOtherWorkflowFailure) {
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                      LoaderUtils.hideLoader(context);
                    } else if (state is TransferToOtherWorkflowSuccess) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.message.isNotEmpty ? state.message : 'Ticket transferred successfully',
                      );
                      if (context.mounted) {
                        if (Navigator.of(context).canPop()) {
                          Navigator.of(context).pop(true);
                        }
                      }
                    }
                  },
                  child: BlocConsumer<AddNewTicketBloc, AddNewTicketState>(
                    listener: (context, state) {
                      if (state is AddNewTicketSubmitLoading) {
                        LoaderUtils.showLoader(context);
                      }
                      if (state is AddNewTicketFailure) {
                        SnackBarUtils.showFloatingSnackBar(
                          context,
                          state.errorMessage,
                        );
                        LoaderUtils.hideLoader(context);
                      }
                      if (state is TicketLocationCategorySuccess) {
                        LoaderUtils.hideLoader(context);
                        _locationCategoryData = state.data;
                        setState(() {});
                      }
                      if (state is TicketSubCategorySuccess) {
                        LoaderUtils.hideLoader(context);
                        subCategories?.clear();
                        if (state.data.subCategories != null) {
                          subCategories = state.data.subCategories!;
                        }
                        debugPrint('subCategories = $subCategories');
                        setState(() {});
                      }
                      if (state is TicketWorkFlowDetailsSuccess) {
                        LoaderUtils.hideLoader(context);
                        workFlowList = state.data.workFlowDetailList ?? [];
                        setState(() {});
                      }
                    },
                    builder: (context, state) {
                      if (_locationCategoryData != null) {
                        final categories =
                            _locationCategoryData!.categoryDetails;

                        return SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const LabelHeading(
                                        label: 'Category',
                                        icon: Icons.local_offer_outlined,
                                      ),
                                      const SizedBox(height: 16),
                                      if (categories != null)
                                        CustomDropDown<CategoryEntity>(
                                          listItems: categories,
                                          selectedValue: _selectedCategory,
                                          label: 'Category',
                                          hintText: 'Select Categories',
                                          searchHintText:
                                              'Search Categories ...',
                                          itemAsString: (category) =>
                                              category.categoryDesc!,
                                          onSelected: (value) {
                                            if (value != null &&
                                                value.categoryId != 0) {
                                              setState(() {
                                                _selectedCategory = value;
                                                _selectedSubCategory = null;
                                                subCategories = [];
                                                workFlowList = [];
                                              });
                                              _validateForm();
                                              debugPrint(
                                                'Selected Category: ${value.categoryId} ${value.categoryDesc}',
                                              );
                                              context.read<AddNewTicketBloc>().add(
                                                FetchTicketSubCategoryRequested(
                                                  value.categoryId ?? 0,
                                                ),
                                              );
                                            }
                                          },
                                          compareFn: (f1, f2) {
                                            return f1.categoryId ==
                                                f2.categoryId;
                                          },
                                        ),
                                      const SizedBox(height: 16),
                                      const LabelHeading(
                                        label: 'Sub Category',
                                        icon: Icons.description_outlined,
                                      ),
                                      const SizedBox(height: 16),

                                      CustomDropDown<SubCategoryEntity>(
                                        listItems: subCategories ?? [],
                                        selectedValue: _selectedSubCategory,
                                        label: 'Sub Category',
                                        hintText: 'Select Sub Categories',
                                        searchHintText:
                                            'Search Sub Categories ...',
                                        itemAsString: (category) =>
                                            category.subCategoryDesc!,
                                        onSelected: (value) {
                                          if (value != null &&
                                              value.subCategoryId != 0) {
                                            setState(() {
                                              _selectedSubCategory = value;
                                              workFlowList = [];
                                            });
                                            _validateForm();
                                            debugPrint(
                                              'Selected CategoryID: ${value.categoryId} --- SubCategoryID: ${value.subCategoryId} ${value.subCategoryDesc}',
                                            );
                                            context.read<AddNewTicketBloc>().add(
                                              FetchTicketWorkFlowDetailsRequested(
                                                value.categoryId ?? 0,
                                                value.subCategoryId ?? 0,
                                              ),
                                            );
                                          }
                                        },
                                        compareFn: (f1, f2) {
                                          return f1.subCategoryId ==
                                              f2.subCategoryId;
                                        },
                                      ),

                                      const SizedBox(height: 16),
                                      WorkflowDetailsSection(
                                        workFlowList: workFlowList,
                                        initialExpanded:
                                            workFlowList.isNotEmpty,
                                      ),
                                      const SizedBox(height: 16),

                                      const LabelHeading(
                                        label: 'Transfer Reason',
                                        icon: Icons.description_outlined,
                                      ),
                                      const SizedBox(height: 16),

                                      TextFormField(
                                        maxLines: 4,
                                        controller: _descriptionController,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Provide a detailed information regarding the issue...',
                                          hintStyle: const TextStyle(
                                            color: AppColors.textSecondary,
                                            fontSize: 14,
                                          ),
                                          filled: true,
                                          fillColor: AppColors.white,
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(
                                              12.0,
                                            ),
                                          ),
                                        ),
                                        textInputAction: TextInputAction.next,
                                        onChanged: (value) {
                                          _validateForm();
                                        },
                                        onEditingComplete: () {
                                          _validateForm();
                                        },
                                        // 'Provide a detailed information regarding the issue'
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _validateForm() {
    if (_selectedCategory != null &&
        _selectedSubCategory != null &&
        _descriptionController.text.isNotEmpty &&
        workFlowList.isNotEmpty) {
      setState(() {
        isSaveBtnEnabled = true;
      });
    } else {
      setState(() {
        isSaveBtnEnabled = false;
      });
    }
  }

  void _transferTicket() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final payload = TransferToOtherWorkflowRequestBody(
        categoryId: _selectedCategory?.categoryId,
        subCategoryId: _selectedSubCategory?.subCategoryId,
        transferReason: _descriptionController.text,
        empCD: state.employeeDetail.empCd,
        companyID: state.employeeDetail.companyId,
        platformType: kIsWeb ? "Web" : "Mobile",
        ticketId: widget.ticketId,
      );
      debugPrint('TransferToOtherWorkflowRequestBody = $payload');
      context.read<TicketingMyActionBloc>().add(
        TransferToOtherWorkflowRequested(payload: payload),
      );
    }
  }
}
