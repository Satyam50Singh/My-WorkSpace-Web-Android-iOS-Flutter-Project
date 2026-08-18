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
  static const String _dateFormatStr = "dd/MM/yyyy";
  final DateFormat _dateFormat = DateFormat(_dateFormatStr);

  DateTimeRange selectedRange = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  final MenuController _menuController = MenuController();
  final ScrollController _calendarScrollController = ScrollController();

  bool showCalendar = false;

  DateTime _displayedMonth = DateTime.now();
  List<DateTime?> _tempValues = [];


  void _setUpdatedSelectedRange(DateTime fromDate, DateTime toDate) {
    if (_menuController.isOpen) {
      _menuController.close();
    }
    setState(() {
      selectedRange = DateTimeRange(start: fromDate, end: toDate);
      showCalendar = false;
    });
    widget.onDateRangeChanged(
      _dateFormat.format(fromDate),
      _dateFormat.format(toDate),
    );
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
    final rangeText =
        "${_dateFormat.format(selectedRange.start)} - ${_dateFormat.format(selectedRange.end)}";

    return MenuAnchor(
      controller: _menuController,
      style: MenuStyle(
        padding: WidgetStateProperty.all(EdgeInsets.zero),
        shape: WidgetStateProperty.all(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevation: WidgetStateProperty.all(12),
        backgroundColor: WidgetStateProperty.all(AppColors.white),
      ),
      menuChildren: showCalendar
          ? [_buildCustomCalendar(isMobile)]
          : _buildPresets(),
      child: InkWell(
        onTap: () {
          if (_menuController.isOpen) {
            _menuController.close();
          } else {
            _menuController.open();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 260),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryDark, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_month, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  rangeText,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_drop_down),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildPresets() {
    return [
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
        final now = DateTime.now();
        final firstDay = DateTime(now.year, now.month, 1);
        final lastDay = DateTime(now.year, now.month + 1, 0);
        _setUpdatedSelectedRange(firstDay, lastDay);
      }),
      _buildMenuItem("Custom Range", () {
        _menuController.close();
        setState(() {
          showCalendar = true;
          _displayedMonth = selectedRange.start;
          _tempValues = [selectedRange.start, selectedRange.end];
        });
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _menuController.open();
        });
      }, icon: Icons.calendar_month),
    ];
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
          const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
        minimumSize: WidgetStateProperty.all(const Size(240, 48)),
      ),
      leadingIcon: icon != null
          ? Icon(icon, size: 20, color: AppColors.slate)
          : null,
      child: Text(
        label,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildCustomCalendar(bool isMobile) {
    if (isMobile) {
      return Container(
        width: 320,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: PrimaryScrollController(
          controller: _calendarScrollController,
          child: CalendarDatePicker2WithActionButtons(
            config: _buildCalendarConfig(),
            value: [selectedRange.start, selectedRange.end],
            onValueChanged: _handleDateRangeChanged,
            onOkTapped: () {},
            onCancelTapped: _resetToPreset,
          ),
        ),
      );
    }
    return Container(
      width: 600,
      child: Column(
        children: [
          SizedBox(
            height: 330,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: CalendarDatePicker2(
                    config: _buildCalendarConfig().copyWith(
                      hideNextMonthIcon: true,
                    ),
                    value: _tempValues,
                    displayedMonthDate: _displayedMonth,
                    onDisplayedMonthChanged: (date) {
                      setState(() {
                        _displayedMonth = date;
                      });
                    },
                    onValueChanged: (values) {
                      setState(() {
                        _tempValues = values;
                      });
                    },
                  ),
                ),
                VerticalDivider(
                  width: 20,
                  thickness: 1,
                  color: AppColors.slate.withOpacity(0.2),
                  indent: 20,
                  endIndent: 20,
                ),
                Expanded(
                  child: CalendarDatePicker2(
                    config: _buildCalendarConfig().copyWith(
                      hideLastMonthIcon: true,
                    ),
                    value: _tempValues,
                    displayedMonthDate: DateTime(
                      _displayedMonth.year,
                      _displayedMonth.month + 1,
                    ),
                    onDisplayedMonthChanged: (date) {
                      setState(() {
                        _displayedMonth = DateTime(date.year, date.month - 1);
                      });
                    },
                    onValueChanged: (values) {
                      setState(() {
                        _tempValues = values;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: _resetToPreset,
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                ElevatedButton(
                  onPressed: () {
                    if (_tempValues.isNotEmpty && _tempValues.first != null) {
                      final start = _tempValues.first!;
                      final end = _tempValues.length > 1 && _tempValues[1] != null ? _tempValues[1]! : start;
                      _setUpdatedSelectedRange(start, end);
                    }
                  },
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleDateRangeChanged(List<DateTime?> values) {
    if (values.length >= 2 && values[0] != null && values[1] != null) {
      _setUpdatedSelectedRange(values[0]!, values[1]!);
    }
  }

  void _resetToPreset() {
    setState(() => showCalendar = false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_menuController.isOpen) _menuController.open();
    });
  }

  CalendarDatePicker2WithActionButtonsConfig _buildCalendarConfig() {
    return CalendarDatePicker2WithActionButtonsConfig(
      calendarType: CalendarDatePicker2Type.range,
      dayMaxWidth: 32,
      useAbbrLabelForMonthModePicker: true,
      centerAlignModePicker: true,
      selectedDayHighlightColor: AppColors.primary,
      weekdayLabelTextStyle: const TextStyle(
        color: AppColors.textSecondary,
        fontWeight: FontWeight.bold,
        fontSize: 12,
      ),
      controlsTextStyle: const TextStyle(
        color: AppColors.textPrimary,
        fontWeight: FontWeight.bold,
        fontSize: 13,
      ),
      selectedRangeHighlightColor: AppColors.primaryLight.withOpacity(0.1),
      closeDialogOnCancelTapped: false,
      closeDialogOnOkTapped: false,
      cancelButton: const Text(
        'Cancel',
        style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold),
      ),
      okButton: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Text(
          'Apply',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
