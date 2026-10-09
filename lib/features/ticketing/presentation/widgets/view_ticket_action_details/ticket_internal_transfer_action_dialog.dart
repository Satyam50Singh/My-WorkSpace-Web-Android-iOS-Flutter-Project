import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/widgets/custom_search_bar.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/utils/loader_utils.dart';
import '../../../domain/entities/ticketing_my_action_entities/ticket_transfer_user_list_entity.dart';
import '../../blocs/ticketing_my_action_bloc/ticketing_my_action_bloc.dart';
import 'custom_data_table_with_pagination.dart';

class TicketInternalTransferActionDialog extends StatefulWidget {
  final int ticketId;
  final Function(String, int) onTransferBtnPressed;
  final Color? color;

  const TicketInternalTransferActionDialog({
    super.key,
    required this.ticketId,
    required this.onTransferBtnPressed,
    this.color,
  });

  @override
  State<TicketInternalTransferActionDialog> createState() =>
      _TicketInternalTransferActionDialogState();
}

class _TicketInternalTransferActionDialogState
    extends State<TicketInternalTransferActionDialog> {
  late final TextEditingController remarkController;

  int selectedUserID = 0;
  List<TicketTransferUserListEntity> userList = [];
  late List<TicketTransferUserListEntity> finalUserList = userList;

  @override
  void initState() {
    super.initState();
    remarkController = TextEditingController();

    final bloc = context.read<TicketingMyActionBloc>();
    bloc.add(TicketTransferUserListRequested(ticketId: widget.ticketId));
  }

  @override
  void dispose() {
    super.dispose();
    remarkController.dispose();
  }

  void searchUser(String query) {
    if (query.trim().isEmpty) {
      setState(() {
        finalUserList = userList;
      });
      return;
    }

    final lowerQuery = query.trim().toLowerCase();

    final filteredList = userList.where((user) {
      final name = (user.userName ?? "").toLowerCase();
      final code = (user.userCode ?? "").toLowerCase();
      final department = (user.department ?? "").toLowerCase();
      return name.contains(lowerQuery) ||
          code.contains(lowerQuery) ||
          department.contains(lowerQuery);
    }).toList();

    setState(() {
      finalUserList = filteredList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TicketingMyActionBloc, TicketingMyActionState>(
      listener: (context, state) {
        if (state is TicketingMyActionLoading) {
          LoaderUtils.showLoader(context);
        } else if (state is TicketTransferUserListSuccess) {
          final data = state.userList;
          setState(() {
            userList = data;
            finalUserList = data;
          });
        }
      },
      builder: (context, state) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Transfer User',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  'Select a user to transfer this ticket',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textSecondary,
                  ),
                ),
                Divider(color: AppColors.border, thickness: 1),
                SizedBox(height: 16),
                if (finalUserList.isNotEmpty) ...[
                  if (kIsWeb) ...[
                    CustomSearchBar(
                      hintText: 'Search User by name, code or department',
                      onChanged: (value) {
                        searchUser(value);
                      },
                      color: widget.color,
                    ),
                    SizedBox(height: 16),
                    if (state is TicketTransferUserListLoading)
                      Center(
                        child: Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: widget.color,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    else
                      CustomDataTableWithPagination(
                        userList: finalUserList,
                        onUserSelected: (userID) {
                          selectedUserID = userID;
                        },
                      ),
                  ] else ...[
                    if (state is TicketTransferUserListLoading)
                      Center(
                        child: Container(
                          width: 24,
                          height: 24,
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(
                            color: widget.color,
                            strokeWidth: 2,
                          ),
                        ),
                      )
                    else
                      SizedBox(
                        height: 280,
                        child: ListView.separated(
                          itemCount: finalUserList.length,
                          separatorBuilder: (_, _) {
                            return const SizedBox(height: 4);
                          },
                          itemBuilder: (context, index) {
                            final user = finalUserList[index];
                            final isSelected =
                                selectedUserID == finalUserList[index].userID;
                            return Card(
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(12),
                                  splashColor: AppColors.amber.withValues(
                                    alpha: 0.25,
                                  ),
                                  highlightColor: AppColors.amber.withValues(
                                    alpha: 0.15,
                                  ),
                                  onTap: () {
                                    setState(() {
                                      selectedUserID =
                                          finalUserList[index].userID ?? 0;
                                    });
                                  },
                                  child: ListTile(
                                    selected: isSelected,
                                    selectedColor: AppColors.amberDark,
                                    title: Text(
                                      user.userName?.toString() ?? "-",
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall
                                          ?.copyWith(
                                            fontSize: 14,
                                            color: AppColors.textPrimary,
                                          ),
                                    ),
                                    trailing: isSelected
                                        ? Icon(
                                            Icons.check_circle,
                                            color: AppColors.amberDark,
                                            size: 20,
                                          )
                                        : null,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                ],
                if (finalUserList.isEmpty) ...[
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 24,
                              color: AppColors.textHint,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No users found',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontSize: 16,
                                    color: AppColors.textPrimary,
                                  ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Try refining your search query or check back later.',
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
                                    fontSize: 12,
                                    color: AppColors.textHint,
                                  ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Remarks',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(width: 4),
                    Text(
                      '*',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(color: AppColors.rose),
                    ),
                  ],
                ),
                TextField(
                  controller: remarkController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'Enter remarks for transferring..',
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.color ?? AppColors.primary,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
                SizedBox(height: 8),
                Divider(color: AppColors.border, thickness: 1),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: Icon(Icons.check_circle_outline_rounded),
                      onPressed: () {
                        if (selectedUserID != 0 &&
                            remarkController.text.toString().isNotEmpty) {
                          widget.onTransferBtnPressed(
                            remarkController.text.toString(),
                            selectedUserID,
                          );
                        }
                      },
                      label: Text('Transfer'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            (selectedUserID == 0 ||
                                remarkController.text.toString().isEmpty)
                            ? widget.color?.withValues(alpha: 0.5)
                            : widget.color,
                        foregroundColor: AppColors.background,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
