import 'package:flutter/material.dart';

import '../../../../../core/common/widgets/custom_drop_down.dart';
import '../add_new_request/label_heading.dart';

class TicketReportFilterDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? selectedValue;

  final String label;
  final String hintText;
  final String searchHintText;

  final String Function(T item) itemAsString;
  final bool Function(T first, T second) compareFn;
  final ValueChanged<T?> onSelected;

  final IconData icon;
  final Color iconColor;

  const TicketReportFilterDropdown({
    super.key,
    required this.items,
    required this.selectedValue,
    required this.label,
    required this.hintText,
    required this.searchHintText,
    required this.itemAsString,
    required this.compareFn,
    required this.onSelected,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: Column(
        children: [
          LabelHeading(
            label: label,
            icon: icon,
            isRequired: false,
            isUppercase: false,
            iconColor: iconColor,
          ),
          const SizedBox(height: 8),
          if (items.isNotEmpty == true)
            CustomDropDown<T>(
              listItems: items,
              selectedValue: selectedValue,
              label: label,
              hintText: hintText,
              searchHintText: searchHintText,
              itemAsString: itemAsString,
              onSelected: onSelected,
              compareFn: compareFn,
            ),
        ],
      ),
    );
  }
}
