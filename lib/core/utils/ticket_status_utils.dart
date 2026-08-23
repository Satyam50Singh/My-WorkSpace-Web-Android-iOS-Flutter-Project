import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class TicketStatusUtils {
  static Color getStatusBorderColor(String text) {
    final status = text.toLowerCase();
    if (status == "open") return AppColors.rose.withValues(alpha: 0.9);
    if (status == "closed") return AppColors.success.withValues(alpha: 0.9);
    if (status == "parked") return AppColors.rose.withValues(alpha: 0.9);
    if (status == "hold") return AppColors.amber.withValues(alpha: 0.9);
    if (status == "expired") return AppColors.slate.withValues(alpha: 0.9);
    if (status == "transferred") return AppColors.blue.withValues(alpha: 0.9);
    if (status == "assigned") return AppColors.error.withValues(alpha: 0.9);
    if (status == "accepted") return AppColors.success.withValues(alpha: 0.9);
    if (status == "in progress") return AppColors.amber.withValues(alpha: 0.9);
    return AppColors.primary.withValues(alpha: 0.9);
  }

  static Color getStatusBgColor(String text) {
    final status = text.toLowerCase();
    if (status == "open") return AppColors.rose.withValues(alpha: 0.3);
    if (status == "closed") return AppColors.success.withValues(alpha: 0.3);
    if (status == "parked") return AppColors.rose.withValues(alpha: 0.3);
    if (status == "hold") return AppColors.amber.withValues(alpha: 0.3);
    if (status == "expired") return AppColors.slate.withValues(alpha: 0.4);
    if (status == "transferred") return AppColors.blue.withValues(alpha: 0.4);
    if (status == "assigned") return AppColors.error.withValues(alpha: 0.4);
    if (status == "accepted") return AppColors.success.withValues(alpha: 0.4);
    if (status == "in progress") return AppColors.amber.withValues(alpha: 0.4);
    return AppColors.primary.withValues(alpha: 0.4);
  }

  static Color getStatusTextColor(String text) {
    final status = text.toLowerCase();
    if (status == "open") return AppColors.rose;
    if (status == "closed") return AppColors.success;
    if (status == "parked") return AppColors.rose;
    if (status == "hold") return AppColors.amber;
    if (status == "expired") return AppColors.slate;
    if (status == "transferred") return AppColors.blue;
    if (status == "assigned") return AppColors.error;
    if (status == "accepted") return AppColors.success;
    if (status == "in progress") return AppColors.amber;
    return AppColors.primary;
  }
}
