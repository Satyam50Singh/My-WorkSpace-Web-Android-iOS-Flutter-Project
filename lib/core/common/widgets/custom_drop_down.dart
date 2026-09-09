import 'package:flutter/material.dart';
import 'package:my_worksphere_web/features/ticketing/domain/entities/add_new_request/ticket_location_category_entity.dart';

class CustomDropDown extends StatefulWidget {
  final List<LocationEntity> items;
  final void Function(int) onSelected;

  const CustomDropDown({
    super.key,
    required this.items,
    required this.onSelected,
  });

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  String? _selectedValue;
  int? _selectedLocId;

  @override
  void initState() {
    super.initState();
    if (widget.items.isNotEmpty) {
      _selectedValue = widget.items[0].locationDesc;
      _selectedLocId = widget.items[0].locationId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;

    return Theme(
      data: Theme.of(context).copyWith(
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        focusColor: Colors.transparent,
      ),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: _selectedValue,
            menuMaxHeight: 280,
            alignment: AlignmentDirectional.bottomStart,
            items: items.map((item) {
              return DropdownMenuItem<String>(
                value: item.locationDesc.toString(),
                child: Text(
                  item.locationDesc.toString(),
                  style: const TextStyle(fontSize: 12),
                ),
              );
            }).toList(),
            onChanged: (String? value) {
              final match = items.firstWhere((i) => i.locationDesc == value);
              setState(() {
                _selectedValue = value;
                _selectedLocId = match.locationId;
              });
              widget.onSelected(_selectedLocId ?? 0);
            },
          ),
        ),
      ),
    );
  }
}
