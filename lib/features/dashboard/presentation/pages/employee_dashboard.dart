import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/features/auth/domain/entities/employee_detail.dart';
import 'package:my_worksphere_web/features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:my_worksphere_web/features/dashboard/presentation/widgets/dashboard_drawer.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../auth/presentation/cubit/employee_detail_cubit.dart';

class EmployeeDashboard extends StatefulWidget {
  final Widget? child;

  const EmployeeDashboard({super.key, required this.child});

  @override
  State<EmployeeDashboard> createState() => _EmployeeDashboardState();
}

class _EmployeeDashboardState extends State<EmployeeDashboard> {
  @override
  Widget build(BuildContext context) {
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
            appBar: isMobile || isMini ? const MobileDashboardAppBar() : null,
            drawer: isMobile || isMini
                ? Drawer(child: DashboardDrawer(employeeDetail: employeeDetail))
                : null,
            body: SafeArea(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  if (isWeb)
                    SizedBox(
                      width: 280,
                      child: DashboardDrawer(employeeDetail: employeeDetail),
                    ),
                  Expanded(
                    child: Column(
                      children: [
                        if (widget.child != null)
                          Expanded(child: widget.child!),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const Center(child: Text("No Data"));
      },
    );
  }
}
