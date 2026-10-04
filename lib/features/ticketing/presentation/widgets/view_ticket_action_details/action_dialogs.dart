import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:my_worksphere_web/core/common/widgets/custom_date_time_picker.dart';
import 'package:my_worksphere_web/core/common/widgets/custom_search_bar.dart';
import 'package:my_worksphere_web/core/utils/loader_utils.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/ticketing_my_action_entities/ticket_transfer_user_list_entity.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/ticketing_my_action_bloc/ticketing_my_action_bloc.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/file_picker_utils.dart';
import '../../../../../core/utils/image_compressor.dart';
import '../../../../../core/utils/permission_utils.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../domain/entities/view_ticket_detail_entities/view_ticket_detail_v6_entity.dart';
import 'custom_data_table_with_pagination.dart';

class ActionDialogs {
  static void showAlreadyAcceptedDialog({
    required BuildContext context,
    required ViewTicketDetailV6Entity ticket,
    required Function(BuildContext) onAcceptTicketPressed,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orange.withOpacity(.2),
                    ),
                    child: Center(
                      child: Icon(Icons.list, color: AppColors.orange),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Ticket Already Accepted',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontSize: 18, color: AppColors.primary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'The ticket has already been accepted by ${ticket.acceptedByUser}. Do you still want to accept it?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => onAcceptTicketPressed(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                    ),
                    child: const Text(
                      'Yes, Accept',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showUpdateTicketActionDialog(
    BuildContext buildContext,
    String heading,
    IconData headerIcon,
    String btnText,
    String hintText,
    void Function(String, String?) onSubmit, {
    Color? color,
  }) {
    TextEditingController remarksController = TextEditingController();

    final isSubmitted = ValueNotifier<bool>(false);
    DateTime? holdUntil;

    showDialog(
      context: buildContext,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final formattedDate = holdUntil != null
                ? DateFormat('dd/MM/yyyy HH:mm a').format(holdUntil!)
                : 'dd/mm/yyyy --:-- --';
            debugPrint(formattedDate);
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            size: 24,
                            headerIcon,
                            color: color ?? AppColors.primaryDark,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              heading,
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          //Spacer(),
                          IconButton(
                            iconSize: 20,
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop(),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Remarks',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '*',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.rose,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: remarksController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: hintText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: color ?? AppColors.primaryDark,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      if (heading.contains("Hold")) ...[
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Text(
                              'Hold Until',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textSecondary,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              '*',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.rose,
                                  ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        InkWell(
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          onTap: () async {
                            final DateTime? selectedDateTime =
                                await CustomDateTimePicker.showDateTimePickerDialog(
                                  context,
                                  use24hFormat: false,
                                  color: color,
                                );
                            if (selectedDateTime != null) {
                              debugPrint(
                                'selectedDateTime ${selectedDateTime}',
                              );
                              setState(() {
                                holdUntil = selectedDateTime;
                              });
                            }
                          },
                          child: InputDecorator(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                            child: Text(formattedDate),
                          ),
                        ),
                        // date picker with time
                        SizedBox(height: 8),
                        Text(
                          'Select the date and time until which this ticket should be on hold.',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.textSecondary,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                        ),
                      ],
                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Spacer(),
                          TextButton(
                            onPressed: () => Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop(),
                            child: Text(
                              'Cancel',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: isSubmitted,
                            builder: (context, loading, child) {
                              return ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      color ?? AppColors.primaryDark,
                                  foregroundColor: AppColors.background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: loading
                                    ? SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.background,
                                        ),
                                      )
                                    : Icon(headerIcon, size: 18),
                                onPressed: () {
                                  if (remarksController.text.trim().isEmpty) {
                                    SnackBarUtils.showFloatingSnackBar(
                                      buildContext,
                                      'Please enter remarks before taking action',
                                    );
                                  } else if (heading.contains("Hold") &&
                                      holdUntil == null) {
                                    SnackBarUtils.showFloatingSnackBar(
                                      buildContext,
                                      'Please select Hold Until date & time',
                                    );
                                  } else {
                                    isSubmitted.value = true;
                                    onSubmit(
                                      remarksController.text.trim(),
                                      formattedDate,
                                    );
                                  }
                                },
                                label: Text(
                                  loading ? 'Submitting...' : btnText,
                                  style: TextStyle(fontSize: 14),
                                ),
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
          },
        );
      },
    );
  }

  static void showCloseTicketActionDialog(
    BuildContext buildContext,
    String heading,
    IconData headerIcon,
    String btnText,
    String hintText,
    void Function(
      String,
      List<Map<String, Uint8List?>>?,
      List<Map<String, File?>>?,
    )
    onSubmit, {
    Color? color,
  }) {
    TextEditingController remarksController = TextEditingController();

    final isSubmitted = ValueNotifier<bool>(false);
    final ImagePicker picker = ImagePicker();

    showDialog(
      context: buildContext,
      builder: (_) {
        List<Map<String, Uint8List?>> selectedWebFiles = [];
        List<Map<String, File?>> selectedFiles = [];

        return StatefulBuilder(
          builder: (context, setState) {
            Future<void> openGallery() async {
              final hasPermission =
                  await PermissionUtils.requestGalleryPermission(context);
              if (!hasPermission) return;
              debugPrint('hasGalleryPermission: $hasPermission');

              try {
                final List<XFile> files = await picker.pickMultiImage(
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

            Future<void> openCamera() async {
              final hasPermission =
                  await PermissionUtils.requestCameraPermission(context);
              if (!hasPermission) return;
              debugPrint('hasCameraPermission: $hasPermission');

              try {
                final XFile? photo = await picker.pickImage(
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

            final galleryBtn = OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.textHint, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(
                Icons.file_upload_outlined,
                size: 18,
                color: AppColors.textHint,
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Gallery',
                  style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                ),
              ),
              onPressed: () {
                if (kIsWeb) {
                  final isMobile = MediaQuery.of(context).size.width < 600;
                  FilePickerUtils.pickFile(
                    isMobile,
                    allowMultiple: true,
                    allowedExtensions: FilePickerUtils.allowedExtensions,
                    selectFile: (files) {},
                    selectWebFile: (files) {
                      setState(() {
                        debugPrint('files = $files');
                        selectedWebFiles.addAll(files);
                        debugPrint('files = ${selectedWebFiles.length}');
                      });
                    },
                  );
                } else {
                  // handle gallery permission and gallery picker
                  openGallery();
                }
              },
            );

            final cameraBtn = OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.textHint, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              icon: Icon(
                Icons.camera_alt_outlined,
                size: 18,
                color: AppColors.textHint,
              ),
              label: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Camera',
                  style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
                ),
              ),
              onPressed: () {
                openCamera();
              },
            );

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 560,
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            size: 24,
                            headerIcon,
                            color: color ?? AppColors.primaryDark,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              heading,
                              style: Theme.of(context).textTheme.headlineLarge
                                  ?.copyWith(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          //Spacer(),
                          IconButton(
                            iconSize: 20,
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop(),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Text(
                            'Closure Remarks',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textSecondary,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '*',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.rose,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: remarksController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          hintText: hintText,
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: color ?? AppColors.primaryDark,
                              width: 2,
                            ),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(height: 16),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        children: [
                          Text(
                            'Attach Photos',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                          ),
                          Text(
                            '(Max 3 MB per image)',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 16,
                        runSpacing: 8,
                        children: [galleryBtn, if (!kIsWeb) cameraBtn],
                      ),
                      // date picker with time
                      SizedBox(height: 8),
                      if (selectedWebFiles.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: selectedWebFiles.length,
                          itemBuilder: (context, index) {
                            final fileMap = selectedWebFiles[index];
                            final bytes = fileMap.values.first as Uint8List;

                            return Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
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
                                        selectedWebFiles.removeAt(index);
                                      });
                                    },
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color: Colors.black54,
                                        shape: BoxShape.circle,
                                      ),
                                      padding: const EdgeInsets.all(2),
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
                      if (selectedFiles.isNotEmpty)
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                              ),
                          itemCount: selectedFiles.length,
                          itemBuilder: (context, index) {
                            final fileMap = selectedFiles[index];
                            final file = fileMap.values.first as File;

                            return Stack(
                              children: [
                                Positioned.fill(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(file, fit: BoxFit.cover),
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
                                      padding: const EdgeInsets.all(2),
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

                      SizedBox(height: 8),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Spacer(),
                          TextButton(
                            onPressed: () => Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop(),
                            child: Text(
                              'Cancel',
                              style: Theme.of(buildContext)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                          ),
                          ValueListenableBuilder(
                            valueListenable: isSubmitted,
                            builder: (context, loading, child) {
                              return ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      color ?? AppColors.primaryDark,
                                  foregroundColor: AppColors.background,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                icon: loading
                                    ? SizedBox(
                                        height: 18,
                                        width: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: AppColors.background,
                                        ),
                                      )
                                    : Icon(headerIcon, size: 18),
                                onPressed: () {
                                  if (remarksController.text.trim().isEmpty) {
                                    SnackBarUtils.showFloatingSnackBar(
                                      buildContext,
                                      'Please enter remarks before taking action',
                                    );
                                  } else {
                                    isSubmitted.value = true;
                                    onSubmit(
                                      remarksController.text.trim(),
                                      selectedWebFiles,
                                      selectedFiles,
                                    );
                                  }
                                },
                                label: Text(
                                  loading ? 'Submitting...' : btnText,
                                  style: TextStyle(fontSize: 14),
                                ),
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
          },
        );
      },
    );
  }

  static void showTransferTicketActionDialog({
    required BuildContext buildContext,
    required Color color,
    required int? ticketId,
    required Function(String, int) onTransferBtnPressed,
  }) {
    SearchController controller = SearchController();
    TextEditingController remarkController = TextEditingController();
    int selectedUserCode = 0;

    if (ticketId != null) {
      final bloc = buildContext.read<TicketingMyActionBloc>();
      bloc.add(TicketTransferUserListRequested(ticketId: ticketId));
    }

    showDialog(
      context: buildContext,
      builder: (_) {
        List<TicketTransferUserListEntity> userList = [];

        List<TicketTransferUserListEntity> finalUserList = userList;

        return StatefulBuilder(
          builder: (context, setState) {
            void searchUser(String query) {
              if (query.isEmpty) return;

              final filteredList = userList.where((user) {
                final name = user.userName ?? "";
                final code = user.userID ?? 0;
                final department = user.department ?? "";
                return name.toLowerCase().contains(query.toLowerCase()) ||
                    code.toString().contains(query.toLowerCase()) ||
                    department.toLowerCase().contains(query.toLowerCase());
              }).toList();

              setState(() {
                finalUserList = filteredList;
              });
            }

            return BlocConsumer<TicketingMyActionBloc, TicketingMyActionState>(
              listener: (context, state) {
                if (state is TicketingMyActionLoading) {
                  LoaderUtils.showLoader(context);
                } else if (state is TicketTransferUserListSuccess) {
                  final data = state.userList;
                  setState(() {
                    userList = data;
                    finalUserList = data;
                  });
                }
              },
              builder: (context, state) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Container(
                    width: 720,
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Transfer User',
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                        ),
                        Text(
                          'Select a user to transfer this ticket',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textSecondary,
                              ),
                        ),
                        Divider(color: AppColors.border, thickness: 1),
                        SizedBox(height: 16),
                        CustomSearchBar(
                          hintText: 'Search User by name, code or department',
                          onChanged: (value) {
                            searchUser(value);
                          },
                          searchController: controller,
                          color: color,
                        ),
                        SizedBox(height: 16),
                        if (state is TicketTransferUserListLoading)
                          Center(
                            child: Container(
                              width: 24,
                              height: 24,
                              alignment: Alignment.center,
                              child: CircularProgressIndicator(
                                color: color,
                                strokeWidth: 2,
                              ),
                            ),
                          )
                        else
                          CustomDataTableWithPagination(
                            userList: finalUserList,
                            onUserSelected: (userCode) {
                              selectedUserCode = int.parse(userCode);
                              debugPrint(
                                'selectedUserCode = $selectedUserCode',
                              );
                            },
                          ),
                        SizedBox(height: 16),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Remarks',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '*',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(color: AppColors.rose),
                            ),
                          ],
                        ),
                        TextField(
                          controller: remarkController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Enter remarks for transferring..',
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: color, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                        SizedBox(height: 8),
                        Divider(color: AppColors.border, thickness: 1),
                        SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton.icon(
                              icon: Icon(Icons.check_circle_outline_rounded),
                              onPressed: () {
                                debugPrint(
                                  'selectedUserCode: $selectedUserCode && ',
                                );
                                if (selectedUserCode != 0 &&
                                    remarkController.text
                                        .toString()
                                        .isNotEmpty) {
                                  onTransferBtnPressed(
                                    remarkController.text.toString(),
                                    selectedUserCode,
                                  );
                                }
                              },
                              label: Text('Transfer'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    (selectedUserCode == 0 ||
                                        remarkController.text
                                            .toString()
                                            .isEmpty)
                                    ? color.withOpacity(0.5)
                                    : color,
                                foregroundColor: AppColors.background,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
