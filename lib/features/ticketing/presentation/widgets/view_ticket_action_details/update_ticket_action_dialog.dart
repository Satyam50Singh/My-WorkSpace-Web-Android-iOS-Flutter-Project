import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../../core/common/widgets/custom_date_time_picker.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/snackbar_utils.dart';

class UpdateTicketActionDialog extends StatefulWidget {
  final String heading;
  final IconData headerIcon;
  final String btnText;
  final String hintText;
  final void Function(String, String?) onSubmit;
  final Color? color;

  const UpdateTicketActionDialog({
    super.key,
    required this.heading,
    required this.headerIcon,
    required this.btnText,
    required this.hintText,
    required this.onSubmit,
    this.color,
  });

  @override
  State<UpdateTicketActionDialog> createState() =>
      _UpdateTicketActionDialogState();
}

class _UpdateTicketActionDialogState extends State<UpdateTicketActionDialog> {
  late final TextEditingController remarksController;

  final isSubmitted = ValueNotifier<bool>(false);
  DateTime? holdUntil;

  @override
  void initState() {
    super.initState();
    remarksController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    remarksController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final formattedDate = holdUntil != null
        ? DateFormat('dd/MM/yyyy HH:mm a').format(holdUntil!)
        : 'dd/mm/yyyy --:-- --';
    debugPrint(formattedDate);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: 400,
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    size: 24,
                    widget.headerIcon,
                    color: widget.color ?? AppColors.primaryDark,
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      widget.heading,
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  //Spacer(),
                  IconButton(
                    iconSize: 20,
                    icon: const Icon(Icons.close),
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Remarks',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '*',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.rose,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              TextField(
                controller: remarksController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: widget.color ?? AppColors.primaryDark,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              if (widget.heading.contains("Hold")) ...[
                SizedBox(height: 16),
                Row(
                  children: [
                    Text(
                      'Hold Until',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textSecondary,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      '*',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.rose,
                          ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                InkWell(
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () async {
                    final DateTime? selectedDateTime =
                        await CustomDateTimePicker.showDateTimePickerDialog(
                          context,
                          use24hFormat: false,
                          color: widget.color,
                        );
                    if (selectedDateTime != null) {
                      debugPrint('selectedDateTime $selectedDateTime');
                      setState(() {
                        holdUntil = selectedDateTime;
                      });
                    }
                  },
                  child: InputDecorator(
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    child: Text(formattedDate),
                  ),
                ),
                // date picker with time
                SizedBox(height: 8),
                Text(
                  'Select the date and time until which this ticket should be on hold.',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
                ),
              ],
              SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Spacer(),
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context, rootNavigator: true).pop(),
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  ValueListenableBuilder(
                    valueListenable: isSubmitted,
                    builder: (context, loading, child) {
                      return ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              widget.color ?? AppColors.primaryDark,
                          foregroundColor: AppColors.background,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        icon: loading
                            ? SizedBox(
                                height: 18,
                                width: 18,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: AppColors.background,
                                ),
                              )
                            : Icon(widget.headerIcon, size: 18),
                        onPressed: () {
                          if (remarksController.text.trim().isEmpty) {
                            SnackBarUtils.showFloatingSnackBar(
                              context,
                              'Please enter remarks before taking action',
                            );
                          } else if (widget.heading.contains("Hold") &&
                              holdUntil == null) {
                            SnackBarUtils.showFloatingSnackBar(
                              context,
                              'Please select Hold Until date & time',
                            );
                          } else {
                            isSubmitted.value = true;
                            widget.onSubmit(
                              remarksController.text.trim(),
                              holdUntil != null ? formattedDate : null,
                            );
                          }
                        },
                        label: Text(
                          loading ? 'Submitting...' : widget.btnText,
                          style: TextStyle(fontSize: 14),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
