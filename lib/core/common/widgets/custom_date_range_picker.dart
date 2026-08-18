import 'package:calendar_date_picker2/calendar_date_picker2.dart';
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
  final ScrollController _calendarScrollController = ScrollController();

  bool showCalendar = false;

  void _setUpdatedSelectedRange(DateTime fromDate, DateTime toDate) {
    setState(() {
      selectedRange = DateTimeRange(start: fromDate, end: toDate);
      showCalendar = false;
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
    _calendarScrollController.dispose();
    _menuController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    final dateFormat = "dd/MM/yyyy";

    final rangeText =
        "${DateFormat(dateFormat).format(selectedRange.start)} - ${DateFormat(dateFormat).format(selectedRange.end)}";

    debugPrint('Range Text: $rangeText');

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
        if (!showCalendar) ...[
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
            final thirtyDays = DateTime.now().subtract(
              const Duration(days: 30),
            );
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
            setState(() {
              showCalendar = true;
            });
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!_menuController.isOpen) {
                _menuController.open();
              }
            });
          }, icon: Icons.calendar_month),
        ] else
          _buildCustomCalendar(isMobile),
      ],

      child: Container(
        constraints: BoxConstraints(maxWidth: 260),
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.primaryDark, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTapUp: (details) {
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

  Widget _buildCustomCalendar(bool isMobile) {
    debugPrint('IsMobile: $isMobile');
    if (isMobile) {
      return Container(
        width: 320,
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: PrimaryScrollController(
          controller: _calendarScrollController,
          child: CalendarDatePicker2WithActionButtons(
            config: _buildCalendarConfig(),
            value: [selectedRange.start, selectedRange.end],
            onValueChanged: (values) => _handleDateRangeChanged(values),
            onOkTapped: () {},
            onCancelTapped: () => _resetToPreset(),
          ),
        ),
      );
    }
    return Placeholder();
  }

  void _handleDateRangeChanged(List<DateTime?> values) {
    if (values.isNotEmpty &&
        values.first != null &&
        values.length > 1 &&
        values[1] != null) {
      _setUpdatedSelectedRange(values[0]!, values[1]!);
    }
    debugPrint('Values: $values');
  }

  void _resetToPreset() {
    setState(() {
      showCalendar = false;
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_menuController.isOpen) {
        _menuController.open();
      }
    });
  }

  CalendarDatePicker2WithActionButtonsConfig _buildCalendarConfig() {
    return CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      dayMaxWidth: 32,
      useAbbrLabelForMonthModePicker: true,
      centerAlignModePicker: true,
      selectedDayHighlightColor: Colors.blue[700],
      weekdayLabelTextStyle: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      controlsTextStyle: const TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      selectedRangeHighlightColor: Colors.blue[50],
      closeDialogOnCancelTapped: false,
      closeDialogOnOkTapped: false,
      cancelButton: Text(
        'Cancel',
        style: TextStyle(color: Colors.blue[700], fontWeight: FontWeight.bold),
      ),
      okButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.blue[700],
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Apply',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
