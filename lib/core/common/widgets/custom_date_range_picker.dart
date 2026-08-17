import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../theme/app_colors.dart';

class CustomDateRangePicker extends StatefulWidget {
  final void Function(String, String) onDateRangeChanged;

  const CustomDateRangePicker({super.key, required this.onDateRangeChanged});

  @override
  State<CustomDateRangePicker> createState() => _CustomDateRangePickerState();
}

class _CustomDateRangePickerState extends State<CustomDateRangePicker> {
  DateTimeRange selectedRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  final MenuController _menuController = MenuController();

  void _setUpdatedSelectedRange(DateTime fromDate, DateTime toDate) {
    setState(() {
      selectedRange = DateTimeRange(start: fromDate, end: toDate);
    });
    widget.onDateRangeChanged(
      DateFormat("dd/MM/yyyy").format(fromDate),
      DateFormat("dd/MM/yyyy").format(toDate),
    );
    if (_menuController.isOpen) {
      _menuController.close();
    }
  }

  @override
  void dispose() {
    super.dispose();
    _menuController.close();
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = "dd/MM/yyyy";

    final rangeText =
        "${DateFormat(dateFormat).format(selectedRange.start)} - ${DateFormat(dateFormat).format(selectedRange.end)}";

    return MenuAnchor(
      controller: _menuController,
      style: MenuStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevation: WidgetStateProperty.all(12),
        backgroundColor: WidgetStateProperty.all(Colors.white),
      ),
      menuChildren: [
        _buildMenuItem("Today", () {
          final today = DateTime.now();
          _setUpdatedSelectedRange(today, today);
        }),
        _buildMenuItem("Yesterday", () {
          final yesterday = DateTime.now().subtract(const Duration(days: 1));
          _setUpdatedSelectedRange(yesterday, yesterday);
        }),
        _buildMenuItem("Last 7 days", () {
          final sevenDays = DateTime.now().subtract(const Duration(days: 7));
          _setUpdatedSelectedRange(sevenDays, DateTime.now());
        }),
        _buildMenuItem("Last 30 days", () {
          final thirtyDays = DateTime.now().subtract(const Duration(days: 30));
          _setUpdatedSelectedRange(thirtyDays, DateTime.now());
        }),
        _buildMenuItem("This Month", () {
          final firstDayOfMonth = DateTime(
            DateTime.now().year,
            DateTime.now().month,
            1,
          );
          final lastDayOfMonth = DateTime(
            DateTime.now().year,
            DateTime.now().month + 1,
            0,
          );
          _setUpdatedSelectedRange(firstDayOfMonth, lastDayOfMonth);
        }),
        _buildMenuItem("Custom Range", () {
          _menuController.close();
        }, icon: Icons.calendar_month),
      ],
      child: Container(
        constraints: BoxConstraints(maxWidth: 260),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryDark, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: () {
            if (_menuController.isOpen) {
              _menuController.close();
            } else {
              _menuController.open();
            }
          },
          hoverColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(Icons.calendar_month),
              SizedBox(width: 8),
              Text(
                rangeText,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    String label,
    VoidCallback onPressed, {
    IconData? icon,
  }) {
    return MenuItemButton(
      onPressed: onPressed,
      style: ButtonStyle(
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        ),
        minimumSize: WidgetStateProperty.all(const Size(240, 52)),
      ),
      leadingIcon: icon != null
          ? Icon(icon, size: 20, color: AppColors.slate)
          : null,
      child: Text(
        label,
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }
}
