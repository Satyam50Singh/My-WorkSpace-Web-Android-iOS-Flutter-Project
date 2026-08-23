import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/image_dialog_utils.dart';
import '../../../domain/entities/view_ticket_detail_v6.dart';

class TicketImagesBottomCard extends StatelessWidget {
  final ViewTicketDetailV6Entity? ticketDetails;

  const TicketImagesBottomCard({super.key, this.ticketDetails});

  List<String> _parseImages(String? images) {
    if (images == null || images.trim().isEmpty) {
      return [];
    }

    return images
        .split(',')
        .map((image) => image.trim())
        .where((image) => image.isNotEmpty)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String>? raisedImages = _parseImages(ticketDetails?.ticketRaisedImage);
    List<String>? closureImages = _parseImages(
      ticketDetails?.ticketClosureImage,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: Card(
          elevation: 2,
          color: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.image_outlined,
                      color: AppColors.slate,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Reported Images:'.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                if (raisedImages.isNotEmpty) ...[
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: raisedImages
                        .map(
                          (image) => InkWell(
                            onTap: () => ImageDialogUtils.showImageDialog(
                              context,
                              image,
                              title: 'Reported Image',
                            ),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ] else
                  const Text('No reported images attached.'),

                const SizedBox(height: 16),

                Row(
                  children: [
                    const Icon(
                      Icons.image_outlined,
                      color: AppColors.slate,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Closure Images:'.toUpperCase(),
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                      textAlign: TextAlign.start,
                      maxLines: 1,
                      softWrap: true,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                if (closureImages.isNotEmpty) ...[
                  Wrap(
                    spacing: 8.0,
                    runSpacing: 8.0,
                    children: closureImages
                        .map(
                          (image) => InkWell(
                            onTap: () => ImageDialogUtils.showImageDialog(
                              context,
                              image,
                              title: 'Closure Image',
                            ),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ] else
                  Text(
                    'No closure images attached.',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.slate,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
