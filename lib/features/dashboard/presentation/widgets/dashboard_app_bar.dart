import 'package:flutter/material.dart';
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
