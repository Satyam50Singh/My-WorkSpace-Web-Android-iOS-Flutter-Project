import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/file_picker_utils.dart';
import '../../../../../core/utils/image_compressor.dart';
import '../../../../../core/utils/permission_utils.dart';
import '../../../../../core/utils/snackbar_utils.dart';

class TicketCloseActionDialog extends StatefulWidget {
  final String heading;
  final IconData headerIcon;
  final String btnText;
  final String hintText;
  final void Function(
    String,
    List<Map<String, Uint8List?>>?,
    List<Map<String, File?>>?,
  )
  onSubmit;
  final Color? color;

  const TicketCloseActionDialog({
    super.key,
    required this.heading,
    required this.headerIcon,
    required this.btnText,
    required this.hintText,
    required this.onSubmit,
    this.color,
  });

  @override
  State<TicketCloseActionDialog> createState() =>
      _TicketCloseActionDialogState();
}

class _TicketCloseActionDialogState extends State<TicketCloseActionDialog> {
  late final TextEditingController remarksController;

  final isSubmitted = ValueNotifier<bool>(false);
  final ImagePicker picker = ImagePicker();
  List<Map<String, Uint8List?>> selectedWebFiles = [];
  List<Map<String, File?>> selectedFiles = [];

  @override
  void initState() {
    super.initState();
    remarksController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    remarksController.dispose();
  }

  Future<void> openGallery() async {
    final hasPermission = await PermissionUtils.requestGalleryPermission(
      context,
    );
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
          final compressedFile = await ImageCompressor.compressMobileFile(
            originalFile,
          );
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
    final hasPermission = await PermissionUtils.requestCameraPermission(
      context,
    );
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
        final compressedFile = await ImageCompressor.compressMobileFile(
          originalFile,
        );
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

  @override
  Widget build(BuildContext context) {
    final galleryBtn = OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: AppColors.textHint, width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
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
                    widget.headerIcon,
                    color: widget.color ?? AppColors.primaryDark,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.heading,
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
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Closure Remarks',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '*',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                  hintText: widget.hintText,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.color ?? AppColors.primaryDark,
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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '(Max 3 MB per image)',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                            child: Image.memory(bytes, fit: BoxFit.cover),
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
                                color: AppColors.black,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: AppColors.white,
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
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
                                color: AppColors.black,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(2),
                              child: const Icon(
                                Icons.close,
                                size: 16,
                                color: AppColors.white,
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
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    child: Text(
                      'Cancel',
                      style: Theme.of(context).textTheme.headlineSmall
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
                              widget.color ?? AppColors.primaryDark,
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
                            : Icon(widget.headerIcon, size: 18),
                        onPressed: () {
                          if (remarksController.text.trim().isEmpty) {
                            SnackBarUtils.showFloatingSnackBar(
                              context,
                              'Please enter remarks before taking action',
                            );
                          } else {
                            isSubmitted.value = true;
                            widget.onSubmit(
                              remarksController.text.trim(),
                              selectedWebFiles,
                              selectedFiles,
                            );
                          }
                        },
                        label: Text(
                          loading ? 'Submitting...' : widget.btnText,
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
  }
}
