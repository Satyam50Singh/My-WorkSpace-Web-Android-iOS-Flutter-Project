import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_worksphere_web/core/common/widgets/custom_date_time_picker.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/snackbar_utils.dart';
import '../../../domain/entities/view_ticket_detail_entities/view_ticket_detail_v6_entity.dart';

class ActionDialogs {
  static void showAlreadyAcceptedDialog({
    required BuildContext context,
    required ViewTicketDetailV6Entity ticket,
    required Function(BuildContext) onAcceptTicketPressed,
  }) {
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.orange.withOpacity(.2),
                    ),
                    child: Center(
                      child: Icon(Icons.list, color: AppColors.orange),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Ticket Already Accepted',
                      style: Theme.of(context).textTheme.headlineLarge
                          ?.copyWith(fontSize: 18, color: AppColors.primary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              Text(
                'The ticket has already been accepted by ${ticket?.acceptedByUser}. Do you still want to accept it?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text(
                      'No',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.orange,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => onAcceptTicketPressed(ctx),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                    ),
                    child: const Text(
                      'Yes, Accept',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void showUpdateTicketActionDialog(
    BuildContext buildContext,
    String heading,
    IconData headerIcon,
    String btnText,
    String hintText,
    void Function(String, String?) onSubmit, {
    Color? color,
  }) {
    TextEditingController remarksController = TextEditingController();

    final isSubmitted = ValueNotifier<bool>(false);
    DateTime? holdUntil;

    showDialog(
      context: buildContext,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            final formattedDate = holdUntil != null
                ? DateFormat('dd/MM/yyyy HH:mm a').format(holdUntil!)
                : 'dd/mm/yyyy --:-- --';
            debugPrint(formattedDate);
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Container(
                width: 400,
                padding: const EdgeInsets.all(20.0),
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
                          headerIcon,
                          color: color ?? AppColors.primaryDark,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            heading,
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
                    TextField(
                      controller: remarksController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: hintText,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: color ?? AppColors.primaryDark,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    if (heading.contains("Hold")) ...[
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
                                color: color,
                              );
                          if (selectedDateTime != null) {
                            debugPrint('selectedDateTime ${selectedDateTime}');
                            setState(() {
                              holdUntil = selectedDateTime;
                            });
                          }
                        },
                        child: InputDecorator(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          child: Text(formattedDate),
                        ),
                      ),
                      // date picker with time
                      SizedBox(height: 8),
                      Text(
                        'Select the date and time until which this ticket should be on hold.',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.textSecondary,
                            ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
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
                        ValueListenableBuilder(
                          valueListenable: isSubmitted,
                          builder: (context, loading, child) {
                            return ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: color ?? AppColors.primaryDark,
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
                                  : Icon(headerIcon, size: 18),
                              onPressed: () {
                                if (remarksController.text.trim().isEmpty) {
                                  SnackBarUtils.showFloatingSnackBar(
                                    buildContext,
                                    'Please enter remarks before taking action',
                                  );
                                } else if (heading.contains("Hold") &&
                                    holdUntil == null) {
                                  SnackBarUtils.showFloatingSnackBar(
                                    buildContext,
                                    'Please select Hold Until date & time',
                                  );
                                } else {
                                  isSubmitted.value = true;
                                  onSubmit(
                                    remarksController.text.trim(),
                                    formattedDate,
                                  );
                                }
                              },
                              label: Text(
                                loading ? 'Submitting...' : btnText,
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
            );
          },
        );
      },
    );
  }
}
