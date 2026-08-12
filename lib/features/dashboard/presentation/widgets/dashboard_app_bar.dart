import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';

class MobileDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MobileDashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              InkWell(
                child: const Icon(Icons.notifications),
                onTap: () {
                  SnackBarUtils.showFloatingSnackBar(context, "Will soon");
                },
              ),
              const SizedBox(width: 10),
              InkWell(
                splashColor: Colors.transparent,
                child: const CircleAvatar(
                  radius: 16,
                  child: Icon(Icons.person, size: 16),
                ),
                onTap: () {
                  SnackBarUtils.showFloatingSnackBar(context, "Will soon");
                },
              ),
              const SizedBox(width: 10),
              InkWell(
                child: const Icon(Icons.more_vert),
                onTap: () {
                  SnackBarUtils.showFloatingSnackBar(context, "Will soon");
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class WebDashboardAppBar extends StatelessWidget {
  const WebDashboardAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.white, width: 0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "My Request",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 240,
                    maxHeight: 36,
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Search...',
                      suffixIcon: const Icon(Icons.search),
                      suffixIconColor: AppColors.primaryDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                IconButton.filled(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.filter_alt_outlined,
                    color: AppColors.white,
                    size: 18,
                  ),
                  style: IconButton.styleFrom(
                    minimumSize: const Size(24, 36),
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  label: const Text("New Request"),
                  icon: const Icon(Icons.add),
                  style: OutlinedButton.styleFrom(
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
                const SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    foregroundColor: AppColors.primaryDark,
                    backgroundColor: AppColors.white,
                    elevation: 4,
                    side: const BorderSide(color: AppColors.primaryDark, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Row(
                    children: [
                      Text(
                        "Export",
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.download_sharp),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
