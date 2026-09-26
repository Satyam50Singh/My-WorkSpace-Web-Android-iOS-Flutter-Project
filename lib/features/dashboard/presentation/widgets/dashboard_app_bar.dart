import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';

class MobileDashboardAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String? title;

  const MobileDashboardAppBar({super.key, this.title});

  @override
  State<MobileDashboardAppBar> createState() => _MobileDashboardAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _MobileDashboardAppBarState extends State<MobileDashboardAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        widget.title ?? '',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
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
            ],
          ),
        ),
      ],
    );
  }
}
