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
  });

  @override
  State<CustomDropDown<T>> createState() => _CustomDropDownState<T>();
}

class _CustomDropDownState<T> extends State<CustomDropDown<T>> {
  T? selectedValue;

  @override
  void initState() {
    super.initState();

    if (widget.selectedValue != null) {
      selectedValue = widget.selectedValue;
    }
  }

  String _itemLabel(T item) {
    return widget.itemAsString?.call(item) ?? item.toString();
  }

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<T>(
      itemAsString: widget.itemAsString,
      compareFn: widget.compareFn,
      items: (filter, loadProps) => widget.listItems
          .where(
            (item) =>
                _itemLabel(item).toLowerCase().contains(filter.toLowerCase()),
          )
          .toList(),
      popupProps: PopupProps.menu(
        showSearchBox: true,
        showSelectedItems: true,
        constraints: const BoxConstraints(maxHeight: 320),
        searchFieldProps: TextFieldProps(
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: widget.searchHintText,
          ),
        ),
        itemBuilder: (context, item, isDisabled, isSelected) {
          return ListTile(
            trailing: isSelected
                ? Icon(
                    Icons.check_circle_outline_sharp,
                    color: Colors.blue.withOpacity(.8),
                    size: 18,
                  )
                : null,
            leading: (item is LocationEntity && item.isLastLocation == true)
                ? const Icon(
                    Icons.access_time_rounded,
                    color: AppColors.primaryDark,
                    size: 18,
                  )
                : (item is LocationEntity && item.isFavouriteLocation == true)
                ? const Icon(Icons.star, color: AppColors.primaryDark, size: 18)
                : null,
            title: Text(
              _itemLabel(item),
              style: isSelected
                  ? TextStyle(
                      color: AppColors.primaryDark,
                      fontWeight: FontWeight.bold,
                    )
                  : null,
            ),
            tileColor: isSelected ? Colors.blue.withOpacity(.2) : null,
          );
        },
      ),
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          hintText: widget.hintText,
          labelText: widget.label,
          border: OutlineInputBorder(),
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
