import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/ticket_sub_category_models/insert_update_sub_category_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/sub_category_master_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticket_sub_category_master_bloc/ticket_sub_category_master_bloc.dart';

import '../../../../core/common/widgets/custom_drop_down.dart';
import '../../../../core/common/widgets/custom_loading_dropdown.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../../domain/entities/ticket_category_entities/ticket_category_entity.dart';
import '../blocs/ticket_category_master_bloc/ticket_category_master_bloc.dart';
import '../widgets/add_new_request/add_new_request_header.dart';
import '../widgets/add_new_request/label_heading.dart';

class AddNewSubCategoryPage extends StatefulWidget {
  final SubCategoryMasterEntity? selectedSubCategory;

  const AddNewSubCategoryPage({super.key, this.selectedSubCategory});

  @override
  State<AddNewSubCategoryPage> createState() => _AddNewSubCategoryPageState();
}

class _AddNewSubCategoryPageState extends State<AddNewSubCategoryPage> {
  late final TextEditingController _subCategoryController;
  final _formKey = GlobalKey<FormState>();

  bool isSaveBtnEnabled = false;

  List<TicketCategoryEntity> categories = [];
  TicketCategoryEntity? _selectedCategory;

  List<String> priorityList = ['Minor', 'Major'];
  String? _selectedPriority;

  @override
  void initState() {
    _subCategoryController = TextEditingController();
    if (widget.selectedSubCategory != null) {
      _subCategoryController.text = widget.selectedSubCategory!.subCategory
          .toString();
      _selectedPriority = widget.selectedSubCategory!.priority;
      _selectedCategory = TicketCategoryEntity(
        categoryID: widget.selectedSubCategory!.categoryID,
        category: widget.selectedSubCategory!.category,
        departmentID: null,
        department: null,
      );
    }
    super.initState();

    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final companyId = state.employeeDetail.companyId;
      if (companyId != null) {
        context.read<TicketCategoryMasterBloc>().add(
          TicketCategoryListRequested(companyID: companyId),
        );
      }
    }
  }

  @override
  void dispose() {
    _subCategoryController.dispose();
    super.dispose();
  }

  void _validateForm() {
    if (_selectedCategory != null &&
        _selectedPriority != null &&
        _subCategoryController.text.isNotEmpty) {
      setState(() {
        isSaveBtnEnabled = true;
      });
    } else {
      setState(() {
        isSaveBtnEnabled = false;
      });
    }
  }

  void _apiCallForAddNewSubCategory() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyID = employee.companyId ?? 0;
      final loggedInUserID = employee.userID?.toString() ?? "0";
      final action = widget.selectedSubCategory != null ? 'U' : 'C';
      final categoryID = _selectedCategory?.categoryID ?? 0;
      final subCategoryID = widget.selectedSubCategory?.subCategoryID ?? 0;
      final subCategory = _subCategoryController.text;
      final priority = _selectedPriority ?? '';
      debugPrint(
        'companyID: $companyID, loggedInUserID: $loggedInUserID, action: $action, categoryID: $categoryID, subCategoryID: $subCategoryID, subCategory: $subCategory, priority: $priority',
      );

      InsertUpdateSubCategoryRequestModel payload =
          InsertUpdateSubCategoryRequestModel(
            categoryID: categoryID,
            subCategoryID: subCategoryID,
            subCategory: subCategory,
            companyID: companyID,
            loggedInUserID: loggedInUserID,
            action: action,
            priority: priority,
          );

      context.read<TicketSubCategoryMasterBloc>().add(
        InsertUpdateSubCategoryRequested(payload: payload),
      );
    }
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
              headingText: 'Add New Sub-Category',
              btnText: 'SAVE',
              onSaveTap: _apiCallForAddNewSubCategory,
              isSaveEnabled: isSaveBtnEnabled,
            ),

            BlocConsumer<TicketCategoryMasterBloc, TicketCategoryMasterState>(
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
              builder: (BuildContext context, TicketCategoryMasterState state) {
                return BlocListener<
                  TicketSubCategoryMasterBloc,
                  TicketSubCategoryMasterState
                >(
                  listener: (context, subCategoryState) {
                    if (subCategoryState is InsertSubCategoryMasterLoading) {
                      LoaderUtils.showLoader(context);
                    } else if (subCategoryState
                        is InsertTicketSubCategoryFailure) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        subCategoryState.errorMessage,
                      );
                    } else if (subCategoryState
                        is UpdateTicketSubCategoryFailure) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        subCategoryState.errorMessage,
                      );
                    } else if (subCategoryState
                        is InsertTicketSubCategorySuccess) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        'Sub-Category added successfully',
                      );
                      context.pop(true);
                    } else if (subCategoryState
                        is UpdateTicketSubCategorySuccess) {
                      LoaderUtils.hideLoader(context);
                      SnackBarUtils.showFloatingSnackBar(
                        context,
                        'Sub-Category Updated Successfully',
                      );
                      context.pop(true);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const LabelHeading(
                                label: 'Sub-Category',
                                icon: Icons.local_offer_outlined,
                              ),
                              const SizedBox(height: 16),
                              TextFormField(
                                controller: _subCategoryController,
                                decoration: InputDecoration(
                                  hintText: 'Enter sub-category description...',
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
                              const SizedBox(height: 16),

                              const LabelHeading(
                                label: 'Category',
                                icon: Icons.bookmark_border,
                              ),
                              const SizedBox(height: 16),
                              if (state is TicketCategoryMasterLoading) ...[
                                CustomLoadingDropdown(label: 'Select Category'),
                              ] else
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
                              const SizedBox(height: 16),

                              const LabelHeading(
                                label: 'Priority',
                                icon: Icons.info_outline,
                              ),
                              const SizedBox(height: 16),

                              CustomDropDown<String>(
                                listItems: priorityList,
                                selectedValue: _selectedPriority,
                                label: 'Category',
                                hintText: 'Select Category',
                                searchHintText: 'Search Category ...',
                                itemAsString: (priority) => priority,
                                onSelected: (value) {
                                  if (value != null) {
                                    setState(() {
                                      _selectedPriority = value;
                                    });
                                    _validateForm();
                                    debugPrint(
                                      'Selected _selectedPriority: $_selectedPriority',
                                    );
                                  }
                                },
                                compareFn: (f1, f2) {
                                  return f1 == f2;
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
