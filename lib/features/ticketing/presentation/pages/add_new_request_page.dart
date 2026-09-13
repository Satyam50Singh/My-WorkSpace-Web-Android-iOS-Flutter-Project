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
  bool showWorkFlowDetails = false;
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

    debugPrint('Page is getting rebuild');

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
                                _buildLabelHeading(
                                  'Location',
                                  Icons.location_on_outlined,
                                ),

                                SizedBox(height: 16),
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
                                SizedBox(height: 16),
                                _buildLabelHeading(
                                  'Category',
                                  Icons.local_offer_outlined,
                                ),
                                SizedBox(height: 16),
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
                                SizedBox(height: 16),
                                _buildLabelHeading(
                                  'Sub Category',
                                  Icons.description_outlined,
                                ),
                                SizedBox(height: 16),

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

                                SizedBox(height: 16),
                                Card(
                                  elevation: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            showWorkFlowDetails =
                                                !showWorkFlowDetails;
                                          });
                                        },
                                        splashColor: Colors.transparent,
                                        hoverColor: Colors.transparent,
                                        focusColor: Colors.transparent,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12.0,
                                            horizontal: 16.0,
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.settings_outlined,
                                                size: 16,
                                                color: AppColors.primary,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                'WORK DETAIL',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      AppColors.textSecondary,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Spacer(),
                                              Icon(
                                                Icons.arrow_drop_down,
                                                size: 18,
                                                color: AppColors.textSecondary,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),

                                      Visibility(
                                        visible: showWorkFlowDetails,
                                        child: Column(
                                          children: [
                                            Divider(
                                              thickness: 1,
                                              color: AppColors.background,
                                            ),
                                            if (workFlowList.isEmpty) ...[
                                              Container(
                                                height: 80,
                                                width: double.infinity,
                                                child: Center(
                                                  child: Text(
                                                    'Select a Sub Category to view the workflow.',
                                                    style: TextStyle(
                                                      fontSize: 14,
                                                      color: AppColors
                                                          .textSecondary,
                                                    ),
                                                    maxLines: 2,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ] else
                                              SizedBox(
                                                height: 360,
                                                child: ListView.builder(
                                                  itemCount:
                                                      workFlowList.length,
                                                  itemBuilder: (context, index) {
                                                    return ListTile(
                                                      leading: CircleAvatar(
                                                        backgroundColor:
                                                            AppColors.primary,
                                                        child: Text(
                                                          '${index + 1}',
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                      title: Text(
                                                        workFlowList[index]
                                                                .userName ??
                                                            '',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      subtitle: Text(
                                                        workFlowList[index]
                                                                .groupName ??
                                                            '',
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 16),

                                _buildLabelHeading(
                                  'Description',
                                  Icons.description_outlined,
                                ),
                                SizedBox(height: 16),

                                TextFormField(
                                  maxLines: 4,
                                  decoration: InputDecoration(
                                    hintText:
                                        'Provide a detailed information regarding the issue...',
                                    hintStyle: TextStyle(
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

                                SizedBox(height: 16),
                                _buildLabelHeading(
                                  'Upload images',
                                  Icons.file_upload_outlined,
                                ),

                                SizedBox(height: 16),
                                InkWell(
                                  onTap: () {
                                    // select file
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
                                  child: Container(
                                    width: double.infinity,
                                    height: 160,
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2.0,
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.file_upload_outlined,
                                            size: 32,
                                            color: Colors.blueAccent.shade700,
                                          ),
                                          SizedBox(height: 16.0),
                                          Text(
                                            isMobile
                                                ? 'Click to Upload'
                                                : 'Drag & drop files or Click to Upload',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blueAccent.shade700,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 8.0),
                                          Text(
                                            'Supports PNG, JPG, JPEG, GIF, WEBP (Max 3 MB per image)',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey.shade700,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            textAlign: TextAlign.center,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                if (selectedFiles.isNotEmpty)
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                        ),
                                    itemCount: selectedFiles.length,
                                    itemBuilder: (context, index) {
                                      final fileMap = selectedFiles[index];
                                      final fileName = fileMap.keys.first;
                                      final file = fileMap.values.first as File;

                                      return Stack(
                                        children: [
                                          Positioned.fill(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.file(
                                                file,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedFiles.removeAt(index);
                                                });
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  2,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                if (selectedWebFiles.isNotEmpty)
                                  GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 8,
                                          mainAxisSpacing: 8,
                                        ),
                                    itemCount: selectedWebFiles.length,
                                    itemBuilder: (context, index) {
                                      final fileMap = selectedWebFiles[index];
                                      final fileName = fileMap.keys.first;
                                      final bytes =
                                          fileMap.values.first as Uint8List;

                                      return Stack(
                                        children: [
                                          Positioned.fill(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Image.memory(
                                                bytes,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 4,
                                            right: 4,
                                            child: InkWell(
                                              onTap: () {
                                                setState(() {
                                                  selectedWebFiles.removeAt(
                                                    index,
                                                  );
                                                });
                                              },
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  color: Colors.black54,
                                                  shape: BoxShape.circle,
                                                ),
                                                padding: const EdgeInsets.all(
                                                  2,
                                                ),
                                                child: const Icon(
                                                  Icons.close,
                                                  size: 16,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      );
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

  Widget _buildLabelHeading(String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        SizedBox(width: 4),
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textSecondary,
            fontSize: 14,
          ),
        ),
        SizedBox(width: 4),
        Text(
          '*',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.rose),
        ),
      ],
    );
  }
}
