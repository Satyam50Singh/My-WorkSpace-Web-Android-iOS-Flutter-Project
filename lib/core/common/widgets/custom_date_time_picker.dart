import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';

class CustomDateTimePicker {
  static Future<DateTime?> showDateTimePickerDialog(BuildContext context, {
    DateTime? initial,
    DateTime? firstDate,
    DateTime? lastDate,
    Color? color,
    bool use24hFormat = true,
  }) {
    final now = DateTime.now();
    final first = firstDate ?? DateTime(now.year, now.month, now.day);
    final last = lastDate ?? now.add(const Duration(days: 365));
    final accent = color ?? Theme
        .of(context)
        .colorScheme
        .primary;

    var selected = initial ?? now.add(const Duration(hours: 1));

    return showDialog<DateTime>(
      context: context,
      builder: (ctx) {
        final isMobile = MediaQuery
            .sizeOf(context)
            .width < 600;
        return StatefulBuilder(
          builder: (ctx, setState) {
            final datePickerWidget = SizedBox(
              width: 320,
              child: Theme(
                data: Theme.of(ctx).copyWith(
                  colorScheme: Theme
                      .of(
                    ctx,
                  )
                      .colorScheme
                      .copyWith(primary: accent),
                ),
                child: CalendarDatePicker(
                  initialDate: selected.isBefore(first) ? first : selected,
                  firstDate: first,
                  lastDate: last,
                  onDateChanged: (d) {
                    selected = DateTime(
                      d.year,
                      d.month,
                      d.day,
                      selected.hour,
                      selected.minute,
                      selected.second,
                    );
                    setState(() {});
                  },
                ),
              ),
            );

            final timePickerWidget = SizedBox(
              width: 220,
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: use24hFormat,
                initialDateTime: selected,
                onDateTimeChanged: (d) {
                  selected = DateTime(
                    selected.year,
                    selected.month,
                    selected.day,
                    d.hour,
                    d.minute,
                    d.second,
                  );
                  setState(() {});
                },
              ),
            );
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: isMobile ? 360 : 640),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: isMobile
                            ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            datePickerWidget,
                            const Divider(
                              height: 24,
                              color: AppColors.textSecondary,
                            ),
                            timePickerWidget,
                          ],
                        )
                            : SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              datePickerWidget,
                              const SizedBox(width: 8),
                              Container(
                                width: 1,
                                height: 260,
                                color: AppColors.textSecondary.withValues(alpha: 0.3),
                              ),
                              const SizedBox(width: 16),
                              timePickerWidget,
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () => Navigator.of(ctx).pop(),
                              hoverColor: Colors.transparent,
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: accent,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () => Navigator.of(ctx).pop(selected),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: accent,
                              ),
                              child: const Text(
                                'OK',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
