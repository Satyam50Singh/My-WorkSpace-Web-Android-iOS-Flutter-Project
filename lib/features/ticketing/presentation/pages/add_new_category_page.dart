import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticket_category_entities/department_entity.dart';

import '../../../../core/common/widgets/custom_drop_down.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';
import '../../domain/entities/ticket_category_entities/ticket_category_entity.dart';
import '../blocs/ticket_category_master_bloc/ticket_category_master_bloc.dart';
import '../widgets/add_new_request/add_new_request_header.dart';
import '../widgets/add_new_request/label_heading.dart';

class AddNewCategoryPage extends StatefulWidget {
  final TicketCategoryEntity? selectedCategory;

  const AddNewCategoryPage({super.key, this.selectedCategory});

  @override
  State<AddNewCategoryPage> createState() => _AddNewCategoryPageState();
}

class _AddNewCategoryPageState extends State<AddNewCategoryPage> {
  late final TextEditingController _categoryController;
  final _formKey = GlobalKey<FormState>();

  bool isSaveBtnEnabled = false;

  List<DepartmentEntity> departments = [];
  DepartmentEntity? _selectedDepartment;

  @override
  void initState() {
    _categoryController = TextEditingController();
    if (widget.selectedCategory != null) {
      _categoryController.text = widget.selectedCategory!.category.toString();
      _selectedDepartment = DepartmentEntity(
        widget.selectedCategory!.departmentID,
        widget.selectedCategory!.department,
      );
    }
    super.initState();

    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyId = employee.companyId;
      if (companyId != null) {
        context.read<TicketCategoryMasterBloc>().add(
          DepartmentMasterListRequested(companyID: companyId),
        );
      }
    }
  }

  @override
  void dispose() {
    _categoryController.dispose();
    super.dispose();
  }

  void _validateForm() {
    if (_selectedDepartment != null && _categoryController.text.isNotEmpty) {
      setState(() {
        isSaveBtnEnabled = true;
      });
    } else {
      setState(() {
        isSaveBtnEnabled = false;
      });
    }
  }

  void _apiCallForAddNewCategory() {
    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final employee = state.employeeDetail;
      final companyId = employee.companyId;
      final loggedInUserID = employee.userID;
      final action = widget.selectedCategory != null ? 'U' : 'C';
      final category = _categoryController.text;
      final departmentID = _selectedDepartment?.departmentID;
      final categoryID = widget.selectedCategory != null
          ? widget.selectedCategory?.categoryID
          : 0;
      if (companyId != null) {
        debugPrint(
          'companyID: $companyId, loggedInUserID: $loggedInUserID, action: $action, category: $category, departmentID: $departmentID, categoryID: $categoryID',
        );
        // context.read<TicketCategoryMasterBloc>().add(
        //   DepartmentMasterListRequested(companyID: companyId),
        // );
      }
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
              headingText: 'Add New Category',
              btnText: 'SAVE',
              onSaveTap: _apiCallForAddNewCategory,
              isSaveEnabled: isSaveBtnEnabled,
            ),

            BlocConsumer<TicketCategoryMasterBloc, TicketCategoryMasterState>(
              listener: (context, state) {
                if (state is TicketCategoryMasterFailure) {
                  LoaderUtils.hideLoader(context);
                  SnackBarUtils.showFloatingSnackBar(
                    context,
                    state.errorMessage,
                  );
                } else if (state is DepartmentMasterListSuccess) {
                  LoaderUtils.hideLoader(context);
                  if (state.departmentList.isNotEmpty) {
                    departments = state.departmentList;
                    setState(() {});
                  }
                }
              },
              builder: (BuildContext context, TicketCategoryMasterState state) {
                return Padding(
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
                              label: 'Category',
                              icon: Icons.local_offer_outlined,
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _categoryController,
                              decoration: InputDecoration(
                                hintText: 'Enter Category description...',
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
                              label: 'Department',
                              icon: Icons.comment,
                            ),
                            const SizedBox(height: 16),
                            if (state is DepartmentMasterListLoading)
                              Container(
                                height: 48,
                                width: double.infinity,
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    children: [
                                      const CircularProgressIndicator(
                                        color: AppColors.textSecondary,
                                        constraints: BoxConstraints(
                                          minHeight: 16,
                                          minWidth: 16,
                                        ),
                                        strokeWidth: 2,
                                      ),
                                      SizedBox(width: 16),
                                      Text(
                                        'Select Department',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            else
                              CustomDropDown<DepartmentEntity>(
                                listItems: departments,
                                selectedValue: _selectedDepartment,
                                label: 'Department',
                                hintText: 'Select Department',
                                searchHintText: 'Search Department ...',
                                itemAsString: (department) =>
                                    department.department!,
                                onSelected: (value) {
                                  if (value != null &&
                                      value.departmentID != 0) {
                                    setState(() {
                                      _selectedDepartment = value;
                                    });
                                    _validateForm();
                                    debugPrint(
                                      'Selected Department: departmentID: ${value.departmentID} & ${value.department}',
                                    );
                                  }
                                },
                                compareFn: (f1, f2) {
                                  return f1.departmentID == f2.departmentID;
                                },
                              ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ],
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
