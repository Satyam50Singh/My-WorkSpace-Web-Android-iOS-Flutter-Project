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

  String selectedCategory = "Today";

  void _setUpdatedSelectedRange(
    DateTime fromDate,
    DateTime toDate,
    String categoryType,
  ) {
    if (_menuController.isOpen) {
      _menuController.close();
    }
    setState(() {
      selectedRange = DateTimeRange(start: fromDate, end: toDate);
      showCalendar = false;
      selectedCategory = categoryType;
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
        _setUpdatedSelectedRange(today, today, "Today");
      }),
      _buildMenuItem("Yesterday", () {
        final yesterday = DateTime.now().subtract(const Duration(days: 1));
        _setUpdatedSelectedRange(yesterday, yesterday, "Yesterday");
      }),
      _buildMenuItem("Last 7 days", () {
        final sevenDays = DateTime.now().subtract(const Duration(days: 7));
        _setUpdatedSelectedRange(sevenDays, DateTime.now(), "Last 7 days");
      }),
      _buildMenuItem("Last 30 days", () {
        final thirtyDays = DateTime.now().subtract(const Duration(days: 30));
        _setUpdatedSelectedRange(thirtyDays, DateTime.now(), "Last 30 days");
      }),
      _buildMenuItem("This Month", () {
        final now = DateTime.now();
        final firstDay = DateTime(now.year, now.month, 1);
        final lastDay = DateTime(now.year, now.month + 1, 0);
        _setUpdatedSelectedRange(firstDay, lastDay, "This Month");
      }),
      _buildMenuItem("Last month", () {
        final now = DateTime.now();
        final firstDay = DateTime(now.year, now.month - 1, 1);
        final lastDay = DateTime(now.year, now.month, 0);
        _setUpdatedSelectedRange(firstDay, lastDay, "Last month");
      }),
      _buildMenuItem("Last 6 months", () {
        final now = DateTime.now();
        final firstDay = DateTime(now.year, now.month - 5, 1);
        final lastDay = DateTime(now.year, now.month, 0);
        _setUpdatedSelectedRange(firstDay, lastDay, "Last 6 months");
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
    bool isSelected = label == selectedCategory;

    return isSelected
        ? Padding(
            padding: const EdgeInsets.all(8.0),
            child: MenuItemButton(
              onPressed: onPressed,
              style: ButtonStyle(
                padding: WidgetStateProperty.all(
                  EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
                minimumSize: WidgetStateProperty.all(const Size(240, 48)),
                backgroundColor: isSelected
                    ? WidgetStateProperty.all(AppColors.primary)
                    : null,
                shape: WidgetStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                elevation: WidgetStateProperty.all(0),
              ),
              leadingIcon: icon != null
                  ? Icon(icon, size: 20, color: AppColors.slate)
                  : null,
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: AppColors.white,
                ),
              ),
            ),
          )
        : MenuItemButton(
            onPressed: onPressed,
            style: ButtonStyle(
              padding: WidgetStateProperty.all(
                EdgeInsets.symmetric(
                  horizontal: isSelected ? 14 : 20,
                  vertical: 12,
                ),
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
    final config = _buildCalendarConfig();

    if (isMobile) {
      return Container(
        width: 320,
        padding: const EdgeInsets.all(8),
        child: PrimaryScrollController(
          controller: _calendarScrollController,
          child: CalendarDatePicker2WithActionButtons(
            config: config,
            value: _tempValues,
            onValueChanged: (values) => setState(() => _tempValues = values),
            onOkTapped: _applySelectedRange,
            onCancelTapped: _resetToPreset,
          ),
        ),
      );
    }

    return SizedBox(
      width: 540,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 240,
            child: Row(
              children: [
                Expanded(child: _buildCalendar(config, isLeft: true)),
                VerticalDivider(
                  width: 1,
                  color: AppColors.slate.withOpacity(0.1),
                  indent: 16,
                  endIndent: 16,
                ),
                Expanded(child: _buildCalendar(config, isLeft: false)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: const Divider(height: 1),
          ),
          _buildDesktopActions(config),
        ],
      ),
    );
  }

  Widget _buildCalendar(
    CalendarDatePicker2WithActionButtonsConfig config, {
    required bool isLeft,
  }) {
    return CalendarDatePicker2(
      config: config.copyWith(
        hideNextMonthIcon: isLeft,
        hideLastMonthIcon: !isLeft,
      ),
      value: _tempValues,
      displayedMonthDate: isLeft
          ? _displayedMonth
          : DateTime(_displayedMonth.year, _displayedMonth.month + 1),
      onDisplayedMonthChanged: (date) {
        setState(() {
          _displayedMonth = isLeft ? date : DateTime(date.year, date.month - 1);
        });
      },
      onValueChanged: (values) => setState(() => _tempValues = values),
    );
  }

  void _applySelectedRange() {
    if (_tempValues.isNotEmpty && _tempValues[0] != null) {
      final start = _tempValues[0]!;
      final end = (_tempValues.length > 1 && _tempValues[1] != null)
          ? _tempValues[1]!
          : start;
      _setUpdatedSelectedRange(start, end, "Custom Range");
    }
  }

  Widget _buildDesktopActions(
    CalendarDatePicker2WithActionButtonsConfig config,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: _resetToPreset,
            child: config.cancelButton ?? const Text("Cancel"),
          ),
          const SizedBox(width: 12),
          InkWell(
            onTap: _applySelectedRange,
            borderRadius: BorderRadius.circular(8),
            child: config.okButton ?? const Text("Apply"),
          ),
        ],
      ),
    );
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
