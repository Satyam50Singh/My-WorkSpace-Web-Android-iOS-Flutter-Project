import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/data/models/employee_login/employee_details_model.dart';
import 'package:my_worksphere_web/features/auth/domain/entities/employee_detail.dart';

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
    final width = MediaQuery.sizeOf(context).width;

    final isMini = width < 360;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;
    final isDesktop = width >= 1024;
    final isWeb = isDesktop || isTablet;

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
          final EmployeeDetail employeeDetail = state.employeeDetail;

          return Scaffold(
            appBar: isMobile || isMini ? _buildAppBar() : null,
            drawer: isMobile || isMini
                ? Drawer(child: _buildDrawer(employeeDetail: employeeDetail))
                : null,
            body: SafeArea(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (isWeb)
                    SizedBox(
                      width: 280,
                      child: _buildDrawer(employeeDetail: employeeDetail),
                    ),
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

  Widget _buildDrawer({EmployeeDetail? employeeDetail}) {
    if (employeeDetail == null) {
      return const SizedBox();
    }

    final List<ModuleAccess> moduleAccess = employeeDetail.moduleAccess ?? [];

    final List<DrawerMenuItems> menuItems = [];

    for (final module in moduleAccess) {
      final List<SubMenuItems> subItems = [];

      // Special case: Merge 'ticketing' sub-modules into 'checklist'
      if (module.moduleName?.toLowerCase() == 'checklist') {
        final ticketingModule = moduleAccess.firstWhere(
          (m) => m.moduleName?.toLowerCase() == 'ticketing',
          orElse: () => ModuleAccessModel(moduleName: '', subModules: []),
        );

        module.subModules?.addAll(ticketingModule.subModules!);
      }

      for (final subModule in module.subModules ?? []) {
        subItems.add(
          SubMenuItems(
            title: subModule.menu ?? '',
            icon: Icons.arrow_right,
            route: subModule.route ?? '',
            isDivider: false,
          ),
        );
      }

      menuItems.add(
        DrawerMenuItems(
          title: module.moduleName ?? '',
          icon: _getModuleIcon(module.moduleName),
          route: getModuleRoute(module.moduleName),
          isDivider: false,
          subItems: subItems,
        ),
      );
    }

    return Column(
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
                child: Icon(Icons.local_mall, size: 48, color: AppColors.white),
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
        if (moduleAccess.isNotEmpty)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: ListView.builder(
                itemCount: menuItems.length,
                itemBuilder: (context, index) {
                  final item = menuItems[index];

                  if (item.subItems.isNotEmpty) {
                    return Theme(
                      data: Theme.of(
                        context,
                      ).copyWith(dividerColor: Colors.transparent),
                      child: ExpansionTile(
                        backgroundColor: Colors.grey.withOpacity(0.05),
                        leading: Icon(item.icon, color: AppColors.primaryDark),
                        title: Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primary,
                        ),
                        children: item.subItems.map((subItem) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 48.0),
                            child: ListTile(
                              title: Text(
                                subItem.title,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () {
                                handleNavigation(
                                  moduleName: subItem.title,
                                  route: subItem.route,
                                );
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  }

                  return ListTile(
                    leading: Icon(item.icon, color: AppColors.primary),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      handleNavigation(
                        moduleName: item.title,
                        route: item.route,
                      );
                    },
                  );
                },
              ),
            ),
          ),

        Divider(color: AppColors.border, thickness: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            leading: Icon(Icons.logout, color: AppColors.primaryDark),
            title: Text(
              'LogOut',
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              context.read<EmployeeDetailCubit>().clearEmployeeDetails();
              context.goNamed(AppRoutes.dashboard);
            },
          ),
        ),
      ],
    );
  }

  IconData _getModuleIcon(String? moduleName) {
    switch (moduleName?.toLowerCase()) {
      case 'ticketing':
        return Icons.confirmation_number_outlined;

      case 'checklist':
        return Icons.checklist_outlined;

      case 'workpermit':
        return Icons.assignment_outlined;

      case 'gatepass':
        return Icons.badge_outlined;

      case 'feedback':
        return Icons.feedback_outlined;

      case 'visitor system':
        return Icons.groups_outlined;

      case 'can':
        return Icons.apartment_outlined;

      case 'fitout':
        return Icons.construction_outlined;

      case 'asset management':
        return Icons.inventory_2_outlined;

      case 'license management':
        return Icons.description_outlined;

      case 'incident management':
        return Icons.warning_amber_outlined;

      default:
        return Icons.home;
    }
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

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              InkWell(
                child: Icon(Icons.notifications),
                onTap: () {
                  SnackBarUtils.showFloatingSnackBar(context, "Will soon");
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
                  SnackBarUtils.showFloatingSnackBar(context, "Will soon");
                },
              ),
              SizedBox(width: 10),
              InkWell(
                child: Icon(Icons.more_vert),
                onTap: () {
                  // will go to profile screen
                  SnackBarUtils.showFloatingSnackBar(context, "Will soon");
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  void handleNavigation({String? moduleName, String? route}) {
    SnackBarUtils.showFloatingSnackBar(
      context,
      'Will redirect to $moduleName via $route',
    );
  }

  String getModuleRoute(String? moduleName) {
    switch (moduleName?.toLowerCase()) {
      case 'ticketing':
        return AppRoutes.ticketing;
      case 'checklist':
        return AppRoutes.checklist;
      case 'workpermit':
        return AppRoutes.workpermit;
      case 'gatepass':
        return AppRoutes.gatepass;
      case 'feedback':
        return AppRoutes.feedback;
      case 'visitor system':
        return AppRoutes.visitorSystem;
      case 'can':
        return AppRoutes.can;
      case 'fitout':
        return AppRoutes.fitout;
      case 'asset management':
        return AppRoutes.assetManagement;
      case 'license management':
        return AppRoutes.licenseManagement;
      case 'incident management':
        return AppRoutes.incidentManagement;
      default:
        return AppRoutes.dashboardPath;
    }
  }
}

class DrawerMenuItems {
  final String title;
  final IconData icon;
  final String route;
  final bool isDivider;
  final List<SubMenuItems> subItems;

  DrawerMenuItems({
    required this.title,
    required this.icon,
    required this.route,
    required this.isDivider,
    required this.subItems,
  });
}

class SubMenuItems {
  final String title;
  final IconData icon;
  final String route;
  final bool isDivider;

  SubMenuItems({
    required this.title,
    required this.icon,
    required this.route,
    required this.isDivider,
  });
}
