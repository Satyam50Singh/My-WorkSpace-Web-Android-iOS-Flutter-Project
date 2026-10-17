import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../domain/entities/ticket_category_entities/ticket_category_entity.dart';

class CategoryMasterListViewMobile extends StatelessWidget {
  final List<TicketCategoryEntity> filteredCategories;
  final Function(String, TicketCategoryEntity) performEditDeleteOperation;

  const CategoryMasterListViewMobile({
    super.key,
    required this.filteredCategories,
    required this.performEditDeleteOperation,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context, index) => const SizedBox(height: 4),
      itemCount: filteredCategories.length,
      itemBuilder: (context, index) {
        final category = filteredCategories[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 16,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.local_offer_outlined, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                category.category ?? "",
                                style: Theme.of(context).textTheme.headlineSmall
                                    ?.copyWith(
                                      fontSize: 14,
                                      color: AppColors.textSecondary,
                                    ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        Row(
                          children: [
                            const Icon(Icons.apartment_outlined, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                category.department ?? "",
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    children: [
                      IconButton.filled(
                        onPressed: () {
                          performEditDeleteOperation("Edit", category);
                        },
                        icon: const Icon(Icons.edit, color: AppColors.white),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(24, 24),
                          backgroundColor: AppColors.primaryDark,
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      IconButton.outlined(
                        onPressed: () {
                          performEditDeleteOperation("Delete", category);
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: AppColors.primaryDark,
                        ),
                        style: IconButton.styleFrom(
                          minimumSize: const Size(24, 24),
                          backgroundColor: AppColors.white,
                          side: const BorderSide(
                            color: AppColors.primaryDark,
                            width: 1,
                          ),
                          // shape: RoundedRectangleBorder(
                          //   borderRadius: BorderRadius.circular(10),
                          // ),
                        ),
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
  }
}
