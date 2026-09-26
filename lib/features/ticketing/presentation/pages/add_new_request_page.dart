import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_worksphere_web/core/common/widgets/custom_drop_down.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/core/utils/file_picker_utils.dart';
import 'package:my_worksphere_web/core/utils/image_compressor.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/add_new_ticket_request_model.dart';
import 'package:my_worksphere_web/features/ticketing/data/models/add_new_request/app_multipart_file.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_location_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_sub_category_entity.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_workflow_details_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/add_new_request_bloc/add_new_ticket_bloc.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/add_new_request_header.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/file_upload_section.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/label_heading.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/add_new_request/workflow_details_section.dart';
import 'package:my_worksphere_web/core/utils/permission_utils.dart';
import 'package:path/path.dart' as p;

import '../../../../core/routes/app_routes.dart';
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
  List<AddNewTicketWorkFlowEntity> workFlowList = [];

  LocationEntity? _selectedLocation;
  CategoryEntity? _selectedCategory;
  SubCategoryEntity? _selectedSubCategory;
  final TextEditingController _descriptionController = TextEditingController();
  bool isSaveBtnEnabled = false;
  ImagePicker _picker = ImagePicker();

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
    return ScaffoldMessenger(
      child: Scaffold(
        backgroundColor: AppColors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            AddNewRequestHeader(
              onSaveTap: _submitNewTicket,
              isSaveEnabled: isSaveBtnEnabled,
            ),
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
                                      selectedValue: _selectedLocation,
                                      label: 'Location',
                                      hintText: 'Select Location',
                                      searchHintText: 'Search Locations ...',
                                      itemAsString: (location) =>
                                          location.locationDesc!,
                                      onSelected: (value) {
                                        setState(() {
                                          _selectedLocation = value;
                                        });
                                        _validateForm();
                                        debugPrint(
                                          'Selected location: ${value?.locationId} ${value?.locationDesc}',
                                        );
                                      },
                                      compareFn: (f1, f2) {
                                        return f1.locationId == f2.locationId;
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
                                        selectedValue: _selectedCategory,
                                        label: 'Category',
                                        hintText: 'Select Categories',
                                        searchHintText: 'Search Categories ...',
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
                                          return f1.categoryId == f2.categoryId;
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
                                      initialExpanded: workFlowList.isNotEmpty,
                                    ),
                                    const SizedBox(height: 16),

                                    const LabelHeading(
                                      label: 'Description',
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

                                    const SizedBox(height: 16),
                                    const LabelHeading(
                                      label: 'Upload images',
                                      icon: Icons.file_upload_outlined,
                                      isRequired: false,
                                    ),

                                    const SizedBox(height: 16),
                                    FileUploadSection(
                                      isMobile: isMobile,
                                      selectedFiles: selectedFiles,
                                      selectedWebFiles: selectedWebFiles,
                                      onUploadTap: () {
                                        if (kIsWeb) {
                                          FilePickerUtils.pickFile(
                                            isMobile,
                                            allowMultiple: true,
                                            allowedExtensions: FilePickerUtils
                                                .allowedExtensions,
                                            selectFile: (files) {
                                              setState(() {
                                                selectedFiles.addAll(files);
                                              });
                                            },
                                            selectWebFile: (files) {
                                              setState(() {
                                                selectedWebFiles.addAll(files);
                                              });
                                            },
                                          );
                                        } else {
                                          _showImageSourceSheet();
                                        }
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

                      if (_finalLocationList.isNotEmpty &&
                          _selectedLocation == null) {
                        _selectedLocation = _finalLocationList[0];
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
                    if (state is AddNewTicketSubmitSuccess) {
                      if (kIsWeb) {
                        Navigator.of(context, rootNavigator: true).pop(true);
                      } else {
                        context.go(AppRoutes.myTickets);
                      }
                    }
                  },
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
        _selectedLocation != null &&
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

  void _submitNewTicket() {
    final List<AppMultipartFile> imageFiles = [];
    if (kIsWeb) {
      for (var file in selectedWebFiles) {
        imageFiles.add(
          AppMultipartFile(name: file.keys.first, bytes: file.values.first),
        );
      }
    } else {
      for (var file in selectedFiles) {
        final ioFile = file.values.first!;
        imageFiles.add(
          AppMultipartFile(
            name: p.basename(file.keys.first),
            path: ioFile.path,
          ),
        );
      }
    }

    final state = context.read<EmployeeDetailCubit>().state;
    if (state is EmployeeDetailFetched) {
      final payload = AddNewTicketRequestModel(
        locationID: _selectedLocation?.locationId,
        categoryID: _selectedCategory?.categoryId,
        subCategoryID: _selectedSubCategory?.subCategoryId,
        ticketMessage: _descriptionController.text,
        empCD: state.employeeDetail.empCd,
        companyID: state.employeeDetail.companyId,
        platformType: kIsWeb ? "Web" : "Mobile",
        isImageUploaded: imageFiles.isNotEmpty ? 1 : 0,
        imageCount: imageFiles.length,
        refNo: _generateRandomNumber(),
      );

      context.read<AddNewTicketBloc>().add(
        AddNewTicketSubmitted(payload, imageFiles),
      );
    }
  }

  int _generateRandomNumber() {
    String randomDigits = List.generate(
      10,
      (_) => Random().nextInt(10).toString(),
    ).join();

    int tenDigitNumber = int.parse(randomDigits);

    return tenDigitNumber;
  }

  void _showImageSourceSheet() {
    showModalBottomSheet(
      context: context,
      builder: (ctx) {
        return SafeArea(
          child: Wrap(
            children: [
              Center(
                child: ListTile(
                  title: const Text(
                    'Select Image Source',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Divider(height: 1, color: Colors.grey.shade300),
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_camera,
                  color: AppColors.primaryDark,
                ),
                title: const Text('Take Photo'),
                onTap: () {
                  Navigator.pop(ctx);
                  _openCamera();
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.photo_library,
                  color: AppColors.primaryDark,
                ),
                title: const Text('Choose from Gallery'),
                onTap: () {
                  Navigator.pop(ctx);
                  _openGallery();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openGallery() async {
    final hasPermission =
        await PermissionUtils.requestGalleryPermission(context);
    if (!hasPermission) return;
    debugPrint('hasGalleryPermission: $hasPermission');

    try {
      final List<XFile> files = await _picker.pickMultiImage(
        imageQuality: 80,
        limit: 20,
      );
      if (files.isNotEmpty) {
        for (final file in files) {
          final originalFile = File(file.path);
          final compressedFile =
              await ImageCompressor.compressMobileFile(originalFile);
          if (compressedFile != null) {
            setState(() {
              selectedFiles.add({file.path: compressedFile});
            });
          }
        }
      }
    } catch (e) {
      debugPrint('Could not open gallery: $e');
    }
  }

  Future<void> _openCamera() async {
    final hasPermission =
        await PermissionUtils.requestCameraPermission(context);
    if (!hasPermission) return;
    debugPrint('hasCameraPermission: $hasPermission');

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        preferredCameraDevice: CameraDevice.rear,
      );
      if (photo != null) {
        final originalFile = File(photo.path);
        final compressedFile =
            await ImageCompressor.compressMobileFile(originalFile);
        if (compressedFile != null) {
          setState(() {
            selectedFiles.add({photo.path: compressedFile});
          });
        }
      }
    } catch (e) {
      debugPrint('Could not open camera: $e');
    }
  }
}
