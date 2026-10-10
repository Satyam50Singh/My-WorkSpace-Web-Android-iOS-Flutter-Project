import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/pages/external_transfer_ticket_page.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_action_details/already_accepted_dialog.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_action_details/ticket_close_action_dialog.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_action_details/ticket_internal_transfer_action_dialog.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/widgets/view_ticket_action_details/update_ticket_action_dialog.dart';

import '../../../domain/entities/view_ticket_detail_entities/view_ticket_detail_v6_entity.dart';

class TicketActionDialogUtils {
  static void showAlreadyAcceptedDialog({
    required BuildContext context,
    required ViewTicketDetailV6Entity ticketDetail,
    required Function(BuildContext) onAcceptTicketPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlreadyAcceptedDialog(
        ticket: ticketDetail,
        onAcceptTicketPressed: onAcceptTicketPressed,
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
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (_) {
        return UpdateTicketActionDialog(
          heading: heading,
          headerIcon: headerIcon,
          btnText: btnText,
          hintText: hintText,
          onSubmit: onSubmit,
          color: color,
        );
      },
    );
  }

  static void showCloseTicketActionDialog(
    BuildContext buildContext,
    String heading,
    IconData headerIcon,
    String btnText,
    String hintText,
    void Function(
      String,
      List<Map<String, Uint8List?>>?,
      List<Map<String, File?>>?,
    )
    onSubmit, {
    Color? color,
  }) {
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      builder: (_) {
        return TicketCloseActionDialog(
          heading: heading,
          headerIcon: headerIcon,
          btnText: btnText,
          hintText: hintText,
          onSubmit: onSubmit,
          color: color,
        );
      },
    );
  }

  static void showTransferTicketActionDialog({
    required BuildContext buildContext,
    required Color color,
    required int? ticketId,
    required Function(String, int) onTransferBtnPressed,
  }) {
    showDialog(
      context: buildContext,
      barrierDismissible: false,
      fullscreenDialog: true,
      builder: (_) {
        return TicketInternalTransferActionDialog(
          ticketId: ticketId ?? 0,
          onTransferBtnPressed: onTransferBtnPressed,
          color: color,
        );
      },
    );
  }

  static void showTicketExternalTransferDialog({
    required BuildContext buildContext,
    required Color color,
    required int? ticketId,
    required Function(String, int) onTransferBtnPressed,
    VoidCallback? onTransferSuccess,
  }) async {
    final width = MediaQuery.sizeOf(buildContext).width;
    final isTablet = width >= 600 && width < 1200;
    final isMobile = width < 600;

    if (isMobile) {
      final result = await buildContext.pushNamed<bool>(
        'external-transfer-ticket',
        pathParameters: {'ticketId': '${ticketId ?? 0}'},
      );
      if (result == true) {
        debugPrint('navigated with true');
        onTransferSuccess?.call();
      }
    } else {
      final dialogWidth = isTablet
          ? 440.0
          : isMobile
          ? 360.0
          : 640.0;

      final result = await showDialog<bool>(
        context: buildContext,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            alignment: Alignment.centerRight,
            insetPadding: EdgeInsets.zero,
            child: SizedBox(
              width: dialogWidth,
              height: double.infinity,
              child: ExternalTransferTicketPage(ticketId: ticketId ?? 0),
            ),
          );
        },
      );

      if (result == true) {
        debugPrint('navigated with true');
        onTransferSuccess?.call();
      }
    }
  }
}
