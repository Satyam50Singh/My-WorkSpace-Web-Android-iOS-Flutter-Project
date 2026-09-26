import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/view_ticket_detail_entities/view_ticket_detail_v6_entity.dart';
import 'label_text.dart';

class ClassificationLocationCard extends StatelessWidget {
  final ViewTicketDetailV6Entity? ticketDetails;

  const ClassificationLocationCard({super.key, this.ticketDetails});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    return Padding(
      padding: EdgeInsets.only(
        left: isMobile ? 16.0 : 8.0,
        right: isMobile ? 16.0 : 8.0,
        bottom: 16.0,
      ),
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.indigo.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.location_on_outlined,
                      color: AppColors.indigo,
                      size: 20,
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Classification & Location',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        LabelText(
                          label: 'Zone & Category details',
                          fontSize: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              Divider(
                color: AppColors.border,
                thickness: 0.5,
                height: 24,
                indent: 0,
                endIndent: 0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.location_on_outlined,
                    color: AppColors.slate,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  LabelText(label: 'Location'),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ticketDetails?.locDesc?.toString() ?? '',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              Divider(
                color: AppColors.border,
                thickness: 0.5,
                height: 24,
                indent: 0,
                endIndent: 0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.bookmark_border,
                    color: AppColors.slate,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  LabelText(label: 'Category'),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ticketDetails?.categoryDesc?.toString() ?? '',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              Divider(
                color: AppColors.border,
                thickness: 0.5,
                height: 24,
                indent: 0,
                endIndent: 0,
              ),
              Row(
                children: [
                  Icon(Icons.sell_outlined, color: AppColors.slate, size: 20),
                  SizedBox(width: 8),
                  LabelText(label: 'Sub Category'),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ticketDetails?.subCategoryDesc?.toString() ?? '',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                    ),
                  ),
                ],
              ),
              Divider(
                color: AppColors.border,
                thickness: 0.5,
                height: 24,
                indent: 0,
                endIndent: 0,
              ),
              Row(
                children: [
                  Icon(
                    Icons.business_outlined,
                    color: AppColors.slate,
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  LabelText(label: 'Assigned Dept'),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      ticketDetails?.assignedDepartment?.toString() ?? '',
                      textAlign: TextAlign.end,
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
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
}
