import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

class TicketingMyRequestWebAppBar extends StatelessWidget {
  final String title;
  final int totalRecordsCount;
  final void Function() onTapExportToExcel;
  final void Function() onTapAddNewRequest;

  const TicketingMyRequestWebAppBar({
    super.key,
    this.title = "My Request",
    required this.totalRecordsCount,
    required this.onTapExportToExcel,
    required this.onTapAddNewRequest,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isCompact = maxWidth < 850;
        final bool isVeryCompact = maxWidth < 550;

        return Container(
          height: 60,
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(
              bottom: BorderSide(color: AppColors.white, width: 0),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (!isVeryCompact)
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      fontSize: maxWidth < 1000 ? 18 : 24,
                      color: AppColors.primaryDark,
                    ),
                  ),
                Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      if (title != 'My Action')
                        if (isCompact)
                          IconButton.filled(
                            onPressed: onTapAddNewRequest,
                            icon: const Icon(Icons.add, color: AppColors.white),
                            style: IconButton.styleFrom(
                              minimumSize: const Size(36, 36),
                              backgroundColor: AppColors.primaryDark,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          )
                        else
                          ElevatedButton.icon(
                            onPressed: onTapAddNewRequest,
                            label: const Text("New Request"),
                            icon: const Icon(Icons.add),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primaryDark,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              foregroundColor: AppColors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                      if (totalRecordsCount > 0) ...[
                        const SizedBox(width: 8),
                        if (isCompact)
                          IconButton.outlined(
                            onPressed: onTapExportToExcel,
                            icon: const Icon(
                              Icons.download_sharp,
                              color: AppColors.primaryDark,
                            ),
                            style: IconButton.styleFrom(
                              minimumSize: const Size(24, 24),
                              backgroundColor: AppColors.white,
                              side: const BorderSide(
                                color: AppColors.primaryDark,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          )
                        else
                          OutlinedButton.icon(
                            onPressed: onTapExportToExcel,
                            label: const Text(
                              "Export",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            icon: const Icon(Icons.download_sharp),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 16,
                              ),
                              foregroundColor: AppColors.primaryDark,
                              backgroundColor: AppColors.white,
                              elevation: 4,
                              side: const BorderSide(
                                color: AppColors.primaryDark,
                                width: 1,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
