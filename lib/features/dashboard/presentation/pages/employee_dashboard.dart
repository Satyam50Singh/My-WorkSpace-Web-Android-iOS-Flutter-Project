import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';

class EmployeeDashboard extends StatefulWidget {
  const EmployeeDashboard({super.key});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  @override
  Widget build(BuildContext buildContext) {
    final isMobile = MediaQuery.sizeOf(buildContext).width < 600;
    final isMini = MediaQuery.sizeOf(buildContext).width < 300;

    return BlocConsumer<EmployeeDetailCubit, EmployeeDetailState>(
      listener: (context, state) {
        if (state is EmployeeDetailCleared) {
          context.go(AppRoutes.onboarding);
        }
      },
      builder: (context, state) {
        if (state is EmployeeDetailInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state is EmployeeDetailFetched) {
          return Scaffold(
            appBar: isMobile || isMini
                ? AppBar(
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            InkWell(
                              child: Icon(Icons.notifications),
                              onTap: () {
                                SnackBarUtils.showFloatingSnackBar(
                                  context,
                                  "Will soon",
                                );
                              },
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              splashColor: Colors.transparent,
                              child: CircleAvatar(
                                radius: 16,
                                child: Icon(Icons.person, size: 16),
                              ),
                              onTap: () {
                                // will go to profile screen
                                SnackBarUtils.showFloatingSnackBar(
                                  context,
                                  "Will soon",
                                );
                              },
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              child: Icon(Icons.more_vert),
                              onTap: () {
                                // will go to profile screen
                                SnackBarUtils.showFloatingSnackBar(
                                  context,
                                  "Will soon",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : null,
            drawer: isMobile || isMini ? Drawer(child: _buildDrawer()) : null,
            body: SafeArea(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (!isMobile) SizedBox(width: 280, child: _buildDrawer()),
                  Expanded(
                    child: Column(
                      children: [
                        if (!isMobile && !isMini) _buildWebAppBar(),

                        Center(
                          child: Text(
                            "Welcome ${state.employeeDetail.fullName}",
                            style: TextStyle(
                              fontSize: isMobile
                                  ? 24
                                  : isMini
                                  ? 16
                                  : 48,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Center(child: Text("No Data"));
      },
    );
  }

  Widget _buildDrawer() {
    return Column(
      children: [
        Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: AppColors.primary,
                border: Border(
                  bottom: BorderSide(color: AppColors.white, width: 0),
                ),
              ),
              child: Column(
                children: [
                  Center(
                    child: Icon(
                      Icons.local_mall,
                      size: 48,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    'Work Sphere',
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 36,
                    ),
                  ),
                  Text(
                    'Streamline mall operations',
                    maxLines: 3,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: AppColors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Home'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            Divider(color: AppColors.border, thickness: 1),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('LogOut'),
              onTap: () {
                context.read<EmployeeDetailCubit>().clearEmployeeDetails();
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildWebAppBar() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: AppColors.background,
        border: Border(bottom: BorderSide(color: AppColors.white, width: 0)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Request",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 240,
                    maxHeight: 36,
                  ),
                  child: TextField(
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Search...',
                      suffixIcon: const Icon(Icons.search),
                      suffixIconColor: AppColors.primaryDark,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),

                IconButton.filled(
                  onPressed: () {},
                  icon: Icon(
                    Icons.filter_alt_outlined,
                    color: AppColors.white,
                    size: 18,
                  ),
                  style: IconButton.styleFrom(
                    minimumSize: Size(24, 36),
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () {},
                  label: Text("New Request"),
                  icon: Icon(Icons.add),
                  style: OutlinedButton.styleFrom(
                    backgroundColor: AppColors.primaryDark,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    foregroundColor: AppColors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 16,
                    ),
                    foregroundColor: AppColors.primaryDark,
                    backgroundColor: AppColors.white,
                    elevation: 4,
                    side: BorderSide(color: AppColors.primaryDark, width: 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: Row(
                    children: [
                      Text(
                        "Export",
                        style: TextStyle(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.download_sharp),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
