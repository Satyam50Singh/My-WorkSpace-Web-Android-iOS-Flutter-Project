import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class FileUploadSection extends StatelessWidget {
  final bool isMobile;
  final List<Map<String, File?>> selectedFiles;
  final List<Map<String, Uint8List?>> selectedWebFiles;
  final VoidCallback onUploadTap;
  final Function(int) onRemoveFile;
  final Function(int) onRemoveWebFile;

  const FileUploadSection({
    super.key,
    required this.isMobile,
    required this.selectedFiles,
    required this.selectedWebFiles,
    required this.onUploadTap,
    required this.onRemoveFile,
    required this.onRemoveWebFile,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onUploadTap,
          child: Container(
            width: double.infinity,
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                width: 2.0,
                color: Colors.grey,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(12.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.file_upload_outlined,
                    size: 32,
                    color: Colors.blueAccent.shade700,
                  ),
                  const SizedBox(height: 16.0),
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
                  const SizedBox(height: 8.0),
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
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
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
                      onTap: () => onRemoveFile(index),
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
        if (selectedWebFiles.isNotEmpty)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
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
                      onTap: () => onRemoveWebFile(index),
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
      ],
    );
  }
}
