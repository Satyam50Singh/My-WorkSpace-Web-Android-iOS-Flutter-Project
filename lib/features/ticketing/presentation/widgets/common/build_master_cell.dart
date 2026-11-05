import 'package:flutter/material.dart';

import '../../../../../core/theme/app_colors.dart';

Widget buildMasterCell(
  BuildContext context,
  String text,
  bool isMobile, {
  Color? color,
}) {
  return isMobile
      ? Text(
          text,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 14,
            color: color ?? AppColors.textPrimary,
          ),
        )
      : Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 14,
              color: color ?? AppColors.textPrimary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        );
}
