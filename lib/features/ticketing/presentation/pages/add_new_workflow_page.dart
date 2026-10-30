import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_workflow_models/workflow_level_model.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/sub_category_master_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/workflow_user_group_list_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_workflow_master_widgets/workflow_level_card.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/ticket_workflow_master_widgets/workflow_outlined_button.dart';

import '../../../../core/common/widgets/custom_drop_down.dart';
import '../../../../core/common/widgets/custom_loading_dropdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/loader_utils.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../../data/models/ticket_workflow_models/insert_update_workflow_request_model.dart';
import '../../domain/entities/ticket_category_entities/ticket_category_entity.dart';
import '../blocs/ticket_category_master_bloc/ticket_category_master_bloc.dart';
import '../blocs/ticket_sub_category_master_bloc/ticket_sub_category_master_bloc.dart';
import '../blocs/ticket_workflow_master_bloc/ticket_workflow_master_bloc.dart';
import '../widgets/add_new_request/label_heading.dart';

class AddNewWorkflowPage extends StatefulWidget {
  final TicketWorkflowMasterEntity? selectedWorkflow;

  const AddNewWorkflowPage({super.key, this.selectedWorkflow});

  @override
  State<AddNewWorkflowPage> createState() => _AddNewWorkflowPageState();
}

class _AddNewWorkflowPageState extends State<AddNewWorkflowPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _workflowController = TextEditingController();

  bool isSaveBtnEnabled = false;
  List<TicketCategoryEntity> categories = [];
  TicketCategoryEntity? _selectedCategory;
  List<SubCategoryMasterEntity> subCategories = [];
  List<SubCategoryMasterEntity> filteredSubCategories = [];
  SubCategoryMasterEntity? _selectedSubCategory;

  List<WorkflowLevelModel> workflowLevels = [WorkflowLevelModel(level: 1)];

  List<WorkflowUserItemEntity>? usersList;

  List<WorkflowGroupItemEntity>? groupUserList;
  var companyId = 0;

  @override
  void initState() {
    super.initState();
    _callInitialAPIsForFetchingDropdownValues();
  }

  void _apiCallForWorkflowDetailByID() {
    if (widget.selectedWorkflow != null) {
      final state = context.read<EmployeeDetailCubit>().state;
      if (state is EmployeeDetailFetched) {
        final employee = state.employeeDetail;
        final companyID = employee.companyId ?? 0;
        final workflowID = widget.selectedWorkflow?.workflowID ?? 0;

        context.read<TicketWorkflowMasterBloc>().add(
          TicketWorkflowDetailByIDRequested(
            companyID: companyID,
            workflowID: workflowID,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _workflowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;

    return Container(
      color: AppColors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 48,
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      isMobile
                          ? 'Workflow Configuration'
                          : 'Workflow Configuration Form',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontSize: isMobile ? 16 : 24,
                            color: AppColors.primaryDark,
                          ),
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  if (isMobile)
                    IconButton.filled(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                      ),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(24, 24),
                        backgroundColor: AppColors.primaryDark,
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryDark,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        foregroundColor: AppColors.white,
                      ),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                        size: 16,
                      ),
                      onPressed: () {
                        context.pop();
                      },
                      label: const Text('Back'),
                    ),
                  SizedBox(width: isMobile ? 4 : 8),
                  if (isMobile)
                    IconButton.filled(
                      onPressed: _apiCallForAddNewWorkflow,
                      icon: const Icon(Icons.add, color: AppColors.white),
                      style: IconButton.styleFrom(
                        minimumSize: const Size(24, 24),
                        backgroundColor: AppColors.btnBgGreen,
                      ),
                    )
                  else
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.btnBgGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 16,
                        ),
                        foregroundColor: AppColors.white,
                      ),
                      icon: const Icon(
                        Icons.add_task,
                        color: AppColors.white,
                        size: 16,
                      ),
                      onPressed: _apiCallForAddNewWorkflow,
                      label: const Text('Save'),
                    ),
                ],
              ),
            ),
            const Divider(color: AppColors.textHint),
            const SizedBox(height: 16),
            MultiBlocListener(
              listeners: [
                BlocListener<
                  TicketWorkflowMasterBloc,
                  TicketWorkflowMasterState
                >(
                  listener: (context, state) {
                    if (state is TicketWorkflowMasterLoading) {
                      LoaderUtils.showLoader(context);
                    } else if (state is TicketWorkflowMasterFailure) {
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                    } else if (state is WorkflowUserGroupMasterSuccess) {
                      LoaderUtils.hideLoader(context);
                      setState(() {
                        usersList = state.data?.userList;
                        groupUserList = state.data?.groupList;
                        _apiCallForWorkflowDetailByID();
                      });
                    } else if (state is InsertUpdateWorkflowMasterSuccess) {
                      LoaderUtils.hideLoader(context);
                      final isEditing = widget.selectedWorkflow != null;
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        isEditing
                            ? 'Workflow Updated Successfully'
                            : 'Workflow Added Successfully',
                      );
                      context.pop(true);
                    } else if (state is TicketWorkflowDetailByIDFailure) {
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                    } else if (state is TicketWorkflowDetailByIDSuccess) {
                      LoaderUtils.hideLoader(context);
                      final workflow = state.workflowDetail?.workflow;
                      if (workflow == null) {
                        return;
                      }
                      _workflowController.text = workflow.workflowName ?? '';
                      final workflowDetails =
                          state.workflowDetail?.workflowDetails;
                      setState(() {
                        if (categories.isNotEmpty) {
                          _selectedCategory = categories
                              .where(
                                (category) =>
                                    category.categoryID == workflow.categoryID,
                              )
                              .firstOrNull;
                        }
                        if (workflow.subCategoryID != 0) {
                          if (subCategories.isNotEmpty) {
                            filteredSubCategories = subCategories
                                .where(
                                  (subCategory) =>
                                      subCategory.categoryID ==
                                      workflow.categoryID,
                                )
                                .toList();
                            _selectedSubCategory = filteredSubCategories
                                .where(
                                  (subCategory) =>
                                      subCategory.subCategoryID ==
                                      workflow.subCategoryID,
                                )
                                .firstOrNull;
                          }
                        }
                        if (workflowDetails != null &&
                            workflowDetails.isNotEmpty) {
                          workflowLevels = workflowDetails.map((w1) {
                            return WorkflowLevelModel(
                              level: w1.level ?? 0,
                              userId: w1.userIDs ?? "0",
                              groupId: w1.groupID ?? 0,
                              escalateTime: w1.escalateTime ?? 0,
                              isEmail: w1.isEmail ?? 0,
                              isSMS: w1.isSMS ?? 0,
                              isAppNotification: w1.isAppNotification ?? 0,
                              isWebNotification: w1.isWebNotification ?? 0,
                            );
                          }).toList();
                        }
                      });
                    }
                  },
                ),
                BlocListener<
                  TicketCategoryMasterBloc,
                  TicketCategoryMasterState
                >(
                  listener: (context, state) {
                    if (state is TicketCategoryMasterFailure) {
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                    } else if (state is TicketCategoryMasterSuccess) {
                      setState(() {
                        categories = state.categoryList;
                        _apiCallForSubCategoryList(companyId);
                      });
                    }
                  },
                ),
                BlocListener<
                  TicketSubCategoryMasterBloc,
                  TicketSubCategoryMasterState
                >(
                  listener: (context, state) {
                    if (state is TicketSubCategoryMasterFailure) {
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        state.errorMessage,
                      );
                    } else if (state is TicketSubCategoryMasterSuccess) {
                      setState(() {
                        subCategories = state.subCategoryList;
                        _apiCallForWorkflowUserGroupList(companyId);
                      });
                    }
                  },
                ),
              ],
              child: Expanded(
                child: ScrollConfiguration(
                  behavior: ScrollConfiguration.of(
                    context,
                  ).copyWith(scrollbars: false),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (!isMobile) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const Expanded(
                                  child: LabelHeading(
                                    label: 'Workflow Description',
                                    icon: Icons.description,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: TextFormField(
                                    controller: _workflowController,
                                    decoration: InputDecoration(
                                      hintText: 'Enter workflow description...',
                                      hintStyle: const TextStyle(
                                        color: AppColors.textSecondary,
                                        fontSize: 14,
                                      ),
                                      filled: true,
                                      fillColor: AppColors.background,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                          12.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],

                          if (isMobile) ...[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const LabelHeading(
                                  label: 'Workflow Description',
                                  icon: Icons.description,
                                ),
                                const SizedBox(height: 8),
                                TextFormField(
                                  controller: _workflowController,
                                  decoration: InputDecoration(
                                    hintText: 'Enter workflow description...',
                                    hintStyle: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.background,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],

                          const SizedBox(height: 16),

                          BlocBuilder<
                            TicketCategoryMasterBloc,
                            TicketCategoryMasterState
                          >(
                            builder: (context, state) {
                              return Column(
                                children: [
                                  if (!isMobile) ...[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Expanded(
                                          child: LabelHeading(
                                            label: 'Category',
                                            icon: Icons.bookmark_border,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        if (state
                                            is TicketCategoryMasterLoading)
                                          const Expanded(
                                            flex: 2,
                                            child: CustomLoadingDropdown(
                                              label: 'Select Category',
                                            ),
                                          )
                                        else
                                          Expanded(
                                            flex: 2,
                                            child: CustomDropDown<TicketCategoryEntity>(
                                              listItems: categories,
                                              selectedValue: _selectedCategory,
                                              label: 'Category',
                                              hintText: 'Select Category',
                                              searchHintText:
                                                  'Search Category ...',
                                              itemAsString: (category) =>
                                                  category.category!,
                                              onSelected: (value) {
                                                if (value != null &&
                                                    value.categoryID != 0) {
                                                  setState(() {
                                                    _selectedCategory = value;
                                                    filteredSubCategories = subCategories
                                                        .where(
                                                          (subCategory) =>
                                                              subCategory
                                                                  .categoryID ==
                                                              _selectedCategory!
                                                                  .categoryID,
                                                        )
                                                        .toList();
                                                    _selectedSubCategory = null;
                                                  });
                                                }
                                              },
                                              compareFn: (f1, f2) {
                                                return f1.categoryID ==
                                                    f2.categoryID;
                                              },
                                            ),
                                          ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ],

                                  if (isMobile) ...[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const LabelHeading(
                                          label: 'Category',
                                          icon: Icons.bookmark_border,
                                        ),
                                        const SizedBox(height: 8),
                                        if (state
                                            is TicketCategoryMasterLoading)
                                          const CustomLoadingDropdown(
                                            label: 'Select Category',
                                          )
                                        else
                                          CustomDropDown<TicketCategoryEntity>(
                                            listItems: categories,
                                            selectedValue: _selectedCategory,
                                            label: 'Category',
                                            hintText: 'Select Category',
                                            searchHintText:
                                                'Search Category ...',
                                            itemAsString: (category) =>
                                                category.category!,
                                            onSelected: (value) {
                                              if (value != null &&
                                                  value.categoryID != 0) {
                                                setState(() {
                                                  _selectedCategory = value;
                                                  filteredSubCategories =
                                                      subCategories
                                                          .where(
                                                            (subCategory) =>
                                                                subCategory
                                                                    .categoryID ==
                                                                _selectedCategory!
                                                                    .categoryID,
                                                          )
                                                          .toList();
                                                  _selectedSubCategory = null;
                                                });
                                              }
                                            },
                                            compareFn: (f1, f2) {
                                              return f1.categoryID ==
                                                  f2.categoryID;
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 16),
                          BlocBuilder<
                            TicketSubCategoryMasterBloc,
                            TicketSubCategoryMasterState
                          >(
                            builder: (context, state) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isMobile) ...[
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Expanded(
                                          child: LabelHeading(
                                            label: 'Sub-Category',
                                            icon: Icons.local_offer_outlined,
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        if (state
                                            is TicketSubCategoryMasterLoading)
                                          const Expanded(
                                            flex: 2,
                                            child: CustomLoadingDropdown(
                                              label: 'Select Sub-Category',
                                            ),
                                          )
                                        else
                                          Expanded(
                                            flex: 2,
                                            child:
                                                CustomDropDown<
                                                  SubCategoryMasterEntity
                                                >(
                                                  listItems:
                                                      filteredSubCategories,
                                                  selectedValue:
                                                      _selectedSubCategory,
                                                  label: 'Sub-Category',
                                                  hintText:
                                                      'Select Sub-Category',
                                                  searchHintText:
                                                      'Search Sub-Category ...',
                                                  itemAsString: (subCategory) =>
                                                      subCategory.subCategory!,
                                                  onSelected: (value) {
                                                    if (value != null &&
                                                        value.subCategoryID !=
                                                            0) {
                                                      setState(() {
                                                        _selectedSubCategory =
                                                            value;
                                                      });
                                                    }
                                                  },
                                                  compareFn: (f1, f2) {
                                                    return f1.subCategoryID ==
                                                        f2.subCategoryID;
                                                  },
                                                ),
                                          ),
                                        const Spacer(),
                                      ],
                                    ),
                                  ],

                                  if (isMobile) ...[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const LabelHeading(
                                          label: 'Sub-Category',
                                          icon: Icons.local_offer_outlined,
                                        ),
                                        const SizedBox(height: 8),
                                        if (state
                                            is TicketSubCategoryMasterLoading)
                                          const CustomLoadingDropdown(
                                            label: 'Select Sub-Category',
                                          )
                                        else
                                          CustomDropDown<
                                            SubCategoryMasterEntity
                                          >(
                                            listItems: filteredSubCategories,
                                            selectedValue: _selectedSubCategory,
                                            label: 'Sub-Category',
                                            hintText: 'Select Sub-Category',
                                            searchHintText:
                                                'Search Sub-Category ...',
                                            itemAsString: (subCategory) =>
                                                subCategory.subCategory!,
                                            onSelected: (value) {
                                              if (value != null &&
                                                  value.subCategoryID != 0) {
                                                setState(() {
                                                  _selectedSubCategory = value;
                                                });
                                              }
                                            },
                                            compareFn: (f1, f2) {
                                              return f1.subCategoryID ==
                                                  f2.subCategoryID;
                                            },
                                          ),
                                      ],
                                    ),
                                  ],
                                ],
                              );
                            },
                          ),

                          const SizedBox(height: 16),

                          Row(
                            children: [
                              const Spacer(),
                              WorkflowOutlinedButton(
                                btnTitle: 'New Level',
                                icon: Icons.add,
                                onPressed: () {
                                  setState(() {
                                    workflowLevels.add(
                                      WorkflowLevelModel(
                                        level: workflowLevels.length + 1,
                                      ),
                                    );
                                    _resetWorkflowLevels();
                                  });
                                },
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),
                          for (int i = 0; i < workflowLevels.length; i++) ...[
                            WorkflowLevelCard(
                              key: ObjectKey(workflowLevels[i]),
                              workflowLevel: workflowLevels[i],
                              usersList: usersList ?? [],
                              groupUserList: groupUserList ?? [],
                              onDeletePressed: (level) {
                                if (workflowLevels.length == 1) {
                                  SnackBarUtils.showFloatingSnackBar(
                                    context,
                                    'At least one level is required',
                                  );
                                  return;
                                }
                                setState(() {
                                  workflowLevels.removeWhere(
                                    (workflowLevel) =>
                                        workflowLevel.level == level,
                                  );
                                  _resetWorkflowLevels();
                                });
                              },
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _resetWorkflowLevels() {
    for (int i = 0; i < workflowLevels.length; i++) {
      workflowLevels[i].level = i + 1;
    }
  }

  void _apiCallForAddNewWorkflow() {
    if (_validateForm()) {
      final state = context.read<EmployeeDetailCubit>().state;
      if (state is EmployeeDetailFetched) {
        final employee = state.employeeDetail;
        final companyID = employee.companyId;
        final loggedInUserID = employee.userID?.toString() ?? "0";
        final isEditing = widget.selectedWorkflow != null;
        final action = isEditing ? 'U' : 'C';
        final categoryID = _selectedCategory?.categoryID ?? 0;
        final subCategoryID = _selectedSubCategory?.subCategoryID ?? 0;
        final workflowId = widget.selectedWorkflow?.workflowID ?? 0;
        final workflowName = _workflowController.text.trim();
        final workflowDetails = workflowLevels.map((e) => e.toJson()).toList();
        debugPrint(
          'companyID: $companyID, loggedInUserID: $loggedInUserID, action: $action, categoryID: $categoryID, subCategoryID: $subCategoryID, workflowId: $workflowId, workflowName: $workflowName, workflowDetails: $workflowDetails',
        );
        final payload = InsertUpdateWorkflowRequestModel(
          categoryId: categoryID,
          subCategoryId: subCategoryID,
          workflowId: workflowId,
          workflowName: workflowName,
          companyId: companyID,
          loggedInUserId: loggedInUserID,
          action: action,
          workflowDetails: workflowDetails,
        );
        context.read<TicketWorkflowMasterBloc>().add(
          InsertUpdateWorkflowListRequested(payload: payload),
        );
      }
    }
  }

  void _callInitialAPIsForFetchingDropdownValues() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      companyId = employee.companyId ?? 0;
      _apiCallForCategoryList(companyId);
    }
  }

  void _apiCallForCategoryList(int companyId) {
    context.read<TicketCategoryMasterBloc>().add(
      TicketCategoryListRequested(companyID: companyId),
    );
  }

  void _apiCallForSubCategoryList(int companyId) {
    context.read<TicketSubCategoryMasterBloc>().add(
      TicketSubCategoryListRequested(companyID: companyId),
    );
  }

  void _apiCallForWorkflowUserGroupList(int companyId) {
    context.read<TicketWorkflowMasterBloc>().add(
      WorkflowUserGroupListRequested(companyID: companyId),
    );
  }

  bool _validateForm() {
    if (_workflowController.text.trim().isEmpty) {
      SnackBarUtils.showFloatingSnackBar(context, 'Enter Workflow Description');
      return false;
    } else if (_selectedCategory == null) {
      SnackBarUtils.showFloatingSnackBar(context, 'Select Category');
      return false;
    } else if (_selectedSubCategory == null) {
      SnackBarUtils.showFloatingSnackBar(context, 'Select Sub-Category');
      return false;
    }

    for (var workflow in workflowLevels) {
      final hasUser =
          workflow.userId != null &&
          workflow.userId != '0' &&
          workflow.userId!.isNotEmpty;
      final hasGroup = workflow.groupId != null && workflow.groupId != 0;

      if (!hasUser && !hasGroup) {
        SnackBarUtils.showFloatingSnackBar(
          context,
          'Please assign a user or group to Level ${workflow.level}',
        );
        return false;
      }

      if (workflow.escalateTime == null || workflow.escalateTime == 0) {
        SnackBarUtils.showFloatingSnackBar(
          context,
          'Escalation Time is required for Level ${workflow.level}',
        );
        return false;
      }
    }

    return true;
  }
}
