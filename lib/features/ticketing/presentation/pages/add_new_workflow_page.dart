import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/sub_category_master_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_workflow_entities/ticket_workflow_master_entity.dart';

import '../../../../core/common/widgets/custom_drop_down.dart';
import '../../../../core/common/widgets/custom_loading_dropdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/snackbar_utils.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../../domain/entities/ticket_category_entities/ticket_category_entity.dart';
import '../blocs/ticket_category_master_bloc/ticket_category_master_bloc.dart';
import '../blocs/ticket_sub_category_master_bloc/ticket_sub_category_master_bloc.dart';
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

  @override
  void initState() {
    _callInitialAPIsForFetchingDropdownValues();
    super.initState();
  }

  @override
  void dispose() {
    _workflowController.clear();
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
                        Navigator.of(context).pop();
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
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppColors.white,
                        size: 16,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: Text('Back'),
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
                      icon: Icon(
                        Icons.add_task,
                        color: AppColors.white,
                        size: 16,
                      ),
                      onPressed: _apiCallForAddNewWorkflow,
                      label: Text('Save'),
                    ),
                ],
              ),
            ),
            Divider(color: AppColors.textHint),
            SizedBox(height: 16),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isMobile) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          child: const LabelHeading(
                            label: 'Workflow Description',
                            icon: Icons.description,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: isMobile ? 1 : 2,
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
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              _validateForm();
                            },
                            onEditingComplete: () {
                              _validateForm();
                            },
                          ),
                        ),
                        const Spacer(),
                      ],
                    ),
                  ],

                  if (isMobile) ...[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const LabelHeading(
                          label: 'Workflow Description',
                          icon: Icons.description,
                        ),
                        const SizedBox(height: 16),
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
                          textInputAction: TextInputAction.next,
                          onChanged: (value) {
                            _validateForm();
                          },
                          onEditingComplete: () {
                            _validateForm();
                          },
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 16),
                  BlocConsumer<
                    TicketCategoryMasterBloc,
                    TicketCategoryMasterState
                  >(
                    builder: (context, state) {
                      return Column(
                        children: [
                          if (!isMobile) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: const LabelHeading(
                                    label: 'Category',
                                    icon: Icons.bookmark_border,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                if (state is TicketCategoryMasterLoading)
                                  Expanded(
                                    flex: isMobile ? 1 : 2,
                                    child: CustomLoadingDropdown(
                                      label: 'Select Category',
                                    ),
                                  )
                                else
                                  Expanded(
                                    flex: isMobile ? 1 : 2,
                                    child: CustomDropDown<TicketCategoryEntity>(
                                      listItems: categories,
                                      selectedValue: _selectedCategory,
                                      label: 'Category',
                                      hintText: 'Select Category',
                                      searchHintText: 'Search Category ...',
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
                                          _validateForm();
                                          debugPrint(
                                            'Selected Category: CategoryID: ${value.categoryID} & ${value.category}',
                                          );
                                        }
                                      },
                                      compareFn: (f1, f2) {
                                        return f1.categoryID == f2.categoryID;
                                      },
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
                                  label: 'Category',
                                  icon: Icons.bookmark_border,
                                ),
                                const SizedBox(height: 16),

                                if (state is TicketCategoryMasterLoading)
                                  CustomLoadingDropdown(
                                    label: 'Select Category',
                                  )
                                else
                                  CustomDropDown<TicketCategoryEntity>(
                                    listItems: categories,
                                    selectedValue: _selectedCategory,
                                    label: 'Category',
                                    hintText: 'Select Category',
                                    searchHintText: 'Search Category ...',
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
                                                    subCategory.categoryID ==
                                                    _selectedCategory!
                                                        .categoryID,
                                              )
                                              .toList();
                                          _selectedSubCategory = null;
                                        });
                                        _validateForm();
                                        debugPrint(
                                          'Selected Category: CategoryID: ${value.categoryID} & ${value.category}',
                                        );
                                      }
                                    },
                                    compareFn: (f1, f2) {
                                      return f1.categoryID == f2.categoryID;
                                    },
                                  ),
                              ],
                            ),
                          ],
                        ],
                      );
                    },
                    listener: (context, state) {
                      if (state is TicketCategoryMasterFailure) {
                        SnackBarUtils.showFloatingSnackBar(
                          context,
                          state.errorMessage,
                        );
                      } else if (state is TicketCategoryMasterSuccess) {
                        setState(() {
                          categories = state.categoryList;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 16),
                  BlocConsumer<
                    TicketSubCategoryMasterBloc,
                    TicketSubCategoryMasterState
                  >(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (!isMobile) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: const LabelHeading(
                                    label: 'Sub-Category',
                                    icon: Icons.local_offer_outlined,
                                  ),
                                ),
                                const SizedBox(width: 16),

                                if (state is TicketSubCategoryMasterLoading)
                                  Expanded(
                                    flex: isMobile ? 1 : 2,
                                    child: CustomLoadingDropdown(
                                      label: 'Select Sub-Category',
                                    ),
                                  )
                                else
                                  Expanded(
                                    flex: isMobile ? 1 : 2,
                                    child: CustomDropDown<SubCategoryMasterEntity>(
                                      listItems: filteredSubCategories,
                                      selectedValue: _selectedSubCategory,
                                      label: 'Category',
                                      hintText: 'Select Sub-Category',
                                      searchHintText: 'Search Sub-Category ...',
                                      itemAsString: (subCategory) =>
                                          subCategory.subCategory!,
                                      onSelected: (value) {
                                        if (value != null &&
                                            value.subCategoryID != 0) {
                                          setState(() {
                                            _selectedSubCategory = value;
                                          });
                                          _validateForm();
                                          debugPrint(
                                            'Selected Sub-Category: SubCategoryID: ${value.subCategoryID} & ${value.subCategory}',
                                          );
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const LabelHeading(
                                  label: 'Sub-Category',
                                  icon: Icons.bookmark_border,
                                ),
                                const SizedBox(height: 16),

                                if (state is TicketSubCategoryMasterLoading)
                                  CustomLoadingDropdown(
                                    label: 'Select Sub-Category',
                                  )
                                else
                                  CustomDropDown<SubCategoryMasterEntity>(
                                    listItems: filteredSubCategories,
                                    selectedValue: _selectedSubCategory,
                                    label: 'Sub-Category',
                                    hintText: 'Select Sub-Category',
                                    searchHintText: 'Search Sub-Category ...',
                                    itemAsString: (subCategory) =>
                                        subCategory.subCategory!,
                                    onSelected: (value) {
                                      if (value != null &&
                                          value.subCategoryID != 0) {
                                        setState(() {
                                          _selectedSubCategory = value;
                                        });
                                        _validateForm();
                                        debugPrint(
                                          'Selected Sub-Category: SubCategoryID: ${value.subCategoryID} & ${value.subCategory}',
                                        );
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
                    listener: (context, state) {
                      if (state is TicketSubCategoryMasterFailure) {
                        SnackBarUtils.showFloatingSnackBar(
                          context,
                          state.errorMessage,
                        );
                      } else if (state is TicketSubCategoryMasterSuccess) {
                        setState(() {
                          subCategories = state.subCategoryList;
                        });
                      }
                    },
                  ),

                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _apiCallForAddNewWorkflow() {}

  void _callInitialAPIsForFetchingDropdownValues() {
    _apiCallForCategoryList();
    _apiCallForSubCategoryList();
  }

  void _apiCallForCategoryList() {
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

  void _validateForm() {}
}
