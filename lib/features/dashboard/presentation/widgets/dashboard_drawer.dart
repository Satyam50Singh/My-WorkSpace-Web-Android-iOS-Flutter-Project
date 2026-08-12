import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/core/routes/app_routes.dart';
import 'package:my_worksphere_web/core/theme/app_colors.dart';
import 'package:my_worksphere_web/core/utils/snackbar_utils.dart';
import 'package:my_worksphere_web/features/auth/domain/entities/employee_detail.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';

import 'drawer_menu_item.dart';

class DashboardDrawer extends StatelessWidget {
  final EmployeeDetail employeeDetail;

  const DashboardDrawer({super.key, required this.employeeDetail});

  @override
  Widget build(BuildContext context) {
    final List<ModuleAccess> moduleAccess = employeeDetail.moduleAccess ?? [];
    final List<DrawerMenuItems> menuItems = [];

    for (final module in moduleAccess) {
      final List<SubMenuItems> subItems = [];
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
          route: _getModuleRoute(module.moduleName),
          isDivider: false,
          subItems: subItems,
        ),
      );
    }

    return Column(
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: AppColors.primary,
            border: Border(
              bottom: BorderSide(color: AppColors.white, width: 0),
            ),
          ),
          child: const Column(
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
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.primary,
                        ),
                        children: item.subItems.map((subItem) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 48.0),
                            child: ListTile(
                              title: Text(
                                subItem.title,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              onTap: () {
                                _handleNavigation(
                                  context: context,
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
                      style: const TextStyle(
                        fontSize: 12.0,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onTap: () {
                      _handleNavigation(
                        context: context,
                        moduleName: item.title,
                        route: item.route,
                      );
                    },
                  );
                },
              ),
            ),
          ),

        const Divider(color: AppColors.border, thickness: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ListTile(
            leading: const Icon(Icons.logout, color: AppColors.primaryDark),
            title: const Text(
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

  String _getModuleRoute(String? moduleName) {
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

  void _handleNavigation({
    required BuildContext context,
    String? moduleName,
    String? route,
  }) {
    SnackBarUtils.showFloatingSnackBar(
      context,
      'Will redirect to $moduleName via $route',
    );
  }
}
