import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_location_category_entity.dart';

class CustomDropDown<T> extends StatefulWidget {
  final List<T> listItems;
  final T? selectedValue;
  final String label;
  final String hintText;
  final String searchHintText;
  final ValueChanged<T?> onSelected;
  final DropdownSearchItemAsString<T>? itemAsString;
  final bool Function(T, T)? compareFn;
  final bool? enabled;

  const CustomDropDown({
    super.key,
    required this.listItems,
    this.selectedValue,
    required this.label,
    required this.hintText,
    required this.searchHintText,
    required this.onSelected,
    this.itemAsString,
    this.compareFn,
    this.enabled,
  });

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
  }

  @override
  void didUpdateWidget(covariant CustomDropDown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedValue != oldWidget.selectedValue) {
      selectedValue = widget.selectedValue;
    }
  }

  String _itemLabel(T item) {
    return widget.itemAsString?.call(item) ?? item.toString();
  }

  @override
  Widget build(BuildContext context) {
    bool isListEmpty = widget.listItems.isEmpty;
    bool isEnabled = widget.enabled ?? !isListEmpty;
    double maxMenuHeight = isListEmpty ? 60 : 300;

    return DropdownSearch<T>(
      itemAsString: widget.itemAsString,
      enabled: isEnabled,
      compareFn: widget.compareFn,
      items: (filter, loadProps) => widget.listItems
          .where(
            (item) =>
                _itemLabel(item).toLowerCase().contains(filter.toLowerCase()),
          )
          .toList(),
      popupProps: PopupProps.menu(
        showSearchBox: !isListEmpty,
        showSelectedItems: true,
        constraints: BoxConstraints(maxHeight: maxMenuHeight),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            hintText: widget.searchHintText,
            prefixIcon: const Icon(Icons.search),
          ),
        ),
        itemBuilder: (context, item, isDisabled, isSelected) {
          final bool isLast =
              (item is LocationEntity && item.isLastLocation == true);
          final bool isFav =
              (item is LocationEntity && item.isFavouriteLocation == true);

          return ListTile(
            trailing: isSelected
                ? Icon(
                    Icons.check_circle_outline_sharp,
                    color: Colors.blue.withOpacity(.8),
                    size: 18,
                  )
                : null,
            leading: isLast
                ? const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.primaryDark,
                    size: 18,
                  )
                : isFav
                ? const Icon(Icons.star, color: AppColors.amber, size: 18)
                : null,
            title: Text(
              _itemLabel(item),
              style: (isSelected)
                  ? const TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    )
                  : const TextStyle(color: AppColors.textPrimary, fontSize: 13),
            ),
            tileColor: isSelected ? Colors.blue.withOpacity(.2) : null,
          );
        },
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.label,
          filled: true,
          fillColor: isEnabled ? AppColors.white : AppColors.background,
          labelStyle: TextStyle(
            color: isEnabled ? AppColors.textSecondary : AppColors.textHint,
            fontSize: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        ),
      ),
      onSelected: (T? value) {
        widget.onSelected(value);
        setState(() {
          selectedValue = value;
        });
      },
      selectedItem: selectedValue,
    );
  }
}
