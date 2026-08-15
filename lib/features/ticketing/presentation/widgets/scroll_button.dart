import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class ScrollButton extends StatelessWidget {
  final IconData icon;
  final bool? enabled;
  final VoidCallback? onPressed;

  const ScrollButton({
    super.key,
    required this.icon,
    this.enabled,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEnabled = enabled == true;
    final width = MediaQuery.sizeOf(context).width;
    final isMini = width < 360;
    final isMobile = width < 600;

    return Material(
      elevation: 4,
      shape: const CircleBorder(),
      color: isEnabled ? AppColors.background : Colors.grey.shade200,
      child: InkWell(
        onTap: isEnabled ? onPressed : null,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: isMini || isMobile ? 28 : 40,
          height: isMini || isMobile ? 28 : 40,
          child: Icon(
            icon,
            size: 24,
            color: isEnabled ? AppColors.primary : Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}
