import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_worksphere_web/core/common/widgets/custom_drop_down.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_location_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_sub_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_workflow_details_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/add_new_request_bloc/add_new_ticket_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/add_new_request_header.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/file_upload_section.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/label_heading.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/workflow_details_section.dart';

import '../../data/models/add_new_request/ticket_location_category_request.dart';

class AddNewRequestPage extends StatefulWidget {
  const AddNewRequestPage({super.key});

  @override
  State<AddNewRequestPage> createState() => _AddNewRequestPageState();
}

class _AddNewRequestPageState extends State<AddNewRequestPage> {
  List<Map<String, File?>> selectedFiles = [];
  List<Map<String, Uint8List?>> selectedWebFiles = [];
  final _formKey = GlobalKey<FormState>();
  List<SubCategoryEntity>? subCategories;
  TicketLocationCategoryEntity? _locationCategoryData;
  List<LocationEntity> _finalLocationList = [];
  List<TicketWorkflowEntity> workFlowList = [];

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
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        AddNewRequestHeader(),

        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<AddNewTicketBloc, AddNewTicketState>(
              builder: (context, state) {
                if (_locationCategoryData != null) {
                  final categories = _locationCategoryData!.categoryDetails;

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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const LabelHeading(
                                  label: 'Location',
                                  icon: Icons.location_on_outlined,
                                ),

                                const SizedBox(height: 16),
                                CustomDropDown<LocationEntity>(
                                  listItems: _finalLocationList,
                                  selectedValue: _finalLocationList.isNotEmpty
                                      ? _finalLocationList[0]
                                      : null,
                                  label: 'Location',
                                  hintText: 'Select Location',
                                  searchHintText: 'Search Locations ...',
                                  itemAsString: (location) =>
                                      location.locationDesc!,
                                  onSelected: (value) {
                                    debugPrint(
                                      'Selected location: ${value?.locationId} ${value?.locationDesc}',
                                    );
                                  },
                                  compareFn: (f1, f2) {
                                    return f1 == f2;
                                  },
                                ),
                                const SizedBox(height: 16),
                                const LabelHeading(
                                  label: 'Category',
                                  icon: Icons.local_offer_outlined,
                                ),
                                const SizedBox(height: 16),
                                if (categories != null)
                                  CustomDropDown<CategoryEntity>(
                                    listItems: categories,
                                    label: 'Category',
                                    hintText: 'Select Categories',
                                    searchHintText: 'Search Categories ...',
                                    itemAsString: (category) =>
                                        category.categoryDesc!,
                                    onSelected: (value) {
                                      if (value != null &&
                                          value.categoryId != 0) {
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
                                      return f1 == f2;
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
                                  label: 'Sub Category',
                                  hintText: 'Select Sub Categories',
                                  searchHintText: 'Search Sub Categories ...',
                                  itemAsString: (category) =>
                                      category.subCategoryDesc!,
                                  onSelected: (value) {
                                    if (value != null &&
                                        value.subCategoryId != 0) {
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
                                    return f1 == f2;
                                  },
                                ),

                                const SizedBox(height: 16),
                                WorkflowDetailsSection(
                                  workFlowList: workFlowList,
                                ),
                                const SizedBox(height: 16),

                                const LabelHeading(
                                  label: 'Description',
                                  icon: Icons.description_outlined,
                                ),
                                const SizedBox(height: 16),

                                TextFormField(
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Provide a detailed information regarding the issue...',
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
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Description is required';
                                    }
                                    return null;
                                  },

                                  // 'Provide a detailed information regarding the issue'
                                ),

                                const SizedBox(height: 16),
                                const LabelHeading(
                                  label: 'Upload images',
                                  icon: Icons.file_upload_outlined,
                                ),

                                const SizedBox(height: 16),
                                FileUploadSection(
                                  isMobile: isMobile,
                                  selectedFiles: selectedFiles,
                                  selectedWebFiles: selectedWebFiles,
                                  onUploadTap: () {
                                    _pickFile(
                                      isMobile,
                                      allowMultiple: false,
                                      allowedExtensions: <String>[
                                        'PNG',
                                        'JPG',
                                        'JPEG',
                                        'WEBG',
                                      ],
                                      selectFile: (file, name) {
                                        setState(() {
                                          selectedFiles.add({name: file});
                                        });
                                      },
                                      selectWebFile: (bytes, name) {
                                        setState(() {
                                          selectedWebFiles.add({name: bytes});
                                        });
                                      },
                                    );
                                  },
                                  onRemoveFile: (index) {
                                    setState(() {
                                      selectedFiles.removeAt(index);
                                    });
                                  },
                                  onRemoveWebFile: (index) {
                                    setState(() {
                                      selectedWebFiles.removeAt(index);
                                    });
                                  },
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
              listener: (context, state) {
                if (state is AddNewTicketLoading) {
                  // LoaderUtils.showLoader(context);
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
                  _finalLocationList.clear();
                  final lastSelectedLocation =
                      state.data.locationDetails![0].lastLocation;
                  final favoriteLocation =
                      state.data.locationDetails![0].favouriteLocation;
                  final allLocation =
                      state.data.locationDetails![0].allLocation;

                  if (lastSelectedLocation != null) {
                    _finalLocationList.add(
                      LocationEntity(
                        locationId: lastSelectedLocation[0].locationId,
                        locationDesc: lastSelectedLocation[0].locationDesc,
                        isLastLocation: true,
                      ),
                    );
                  }
                  if (favoriteLocation != null) {
                    for (var location in favoriteLocation) {
                      _finalLocationList.add(
                        LocationEntity(
                          locationId: location.locationId,
                          locationDesc: location.locationDesc,
                          isFavouriteLocation: true,
                        ),
                      );
                    }
                  }
                  if (allLocation != null) {
                    _finalLocationList.addAll(allLocation);
                  }
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
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _pickFile(
    bool isMobile, {
    required List<String>? allowedExtensions,
    required bool allowMultiple,
    required Function(File?, String) selectFile,
    required Function(Uint8List? bytes, String fileName) selectWebFile,
  }) async {
    List<PlatformFile> files = await FilePicker.pickFiles(
      allowMultiple: allowMultiple,
      type: FileType.custom,
      allowedExtensions: allowedExtensions,
    );

    if (files.isEmpty) return;

    final pickedFile = files.first;
    debugPrint('name = ${pickedFile.name}');

    if (kIsWeb) {
      final bytes = await pickedFile.readAsBytes();
      selectWebFile(bytes, pickedFile.name);
    } else {
      if (pickedFile.path != null) {
        final file = File(pickedFile.path!);
        selectFile(file, pickedFile.name);
      }
    }
  }
}
