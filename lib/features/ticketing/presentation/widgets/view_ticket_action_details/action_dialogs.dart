import 'package:flutter/material.dart';

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
    BuildContext context,
    String heading,
    IconData headerIcon,
    String btnText,
    String hintText,
    void Function(String) onSubmit,
  ) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    TextEditingController remarksController = TextEditingController();

    final isSubmitted = ValueNotifier<bool>(false);

    showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: SizedBox(
            width: isMobile
                ? MediaQuery.sizeOf(context).width * 1
                : MediaQuery.sizeOf(context).width * 0.4,
            height: MediaQuery.sizeOf(context).height * 0.35,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          size: 18,
                          headerIcon,
                          color: AppColors.primaryDark,
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          heading,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      //Spacer(),
                      IconButton(
                        iconSize: 18,
                        icon: const Icon(Icons.close),
                        onPressed: () =>
                            Navigator.of(context, rootNavigator: true).pop(),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Remarks*',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  TextField(
                    controller: remarksController,
                    maxLines: 4,
                    decoration: InputDecoration(hint: Text(hintText)),
                  ),
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
                              backgroundColor: AppColors.primaryDark,
                              foregroundColor: AppColors.background,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: loading
                                ? SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: AppColors.background,
                                    ),
                                  )
                                : Icon(headerIcon, size: 16),
                            onPressed: () {
                              if (remarksController.text.trim().isNotEmpty) {
                                isSubmitted.value = true;
                                onSubmit(remarksController.text.trim());
                              } else {
                                SnackBarUtils.showFloatingSnackBar(
                                  context,
                                  'Please enter remarks before submitting',
                                );
                              }
                            },
                            label: Text(loading ? 'Submitting...' : btnText),
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
      },
    );
  }
}
