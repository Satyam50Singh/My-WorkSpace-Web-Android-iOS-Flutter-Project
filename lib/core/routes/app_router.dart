import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/features/dashboard/presentation/pages/dashboard_home.dart';
import 'package:my_worksphere_web/features/dashboard/presentation/pages/employee_dashboard.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/pages/add_new_request_page.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/pages/ticketing_my_request.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/pages/view_ticket_details.dart';

import '../../features/auth/presentation/cubit/employee_detail_cubit.dart';
import '../../features/auth/presentation/pages/user_login_page.dart';
import '../../features/auth/presentation/pages/user_onboard_page.dart';
import '../di/injection_container.dart';
import 'app_routes.dart';

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.onboarding,
    refreshListenable: GoRouterRefreshStream(sl<EmployeeDetailCubit>().stream),
    redirect: _redirect,
    routes: [
      GoRoute(
        path: AppRoutes.onboarding,
        name: 'user-onboard',
        builder: (context, state) => const UserOnboardPage(),
      ),
      GoRoute(
        path: AppRoutes.loginPath,
        name: AppRoutes.login,
        builder: (context, state) {
          final companyId = state.pathParameters['companyId'];
          return UserLoginPage(companyId: companyId);
        },
      ),

      ShellRoute(
        builder: (context, state, child) {
          return EmployeeDashboard(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.dashboardPath,
            name: AppRoutes.dashboard,
            builder: (context, state) {
              return const DashboardHome();
            },
          ),
          GoRoute(
            path: AppRoutes.myTickets,
            name: AppRoutes.myTickets.replaceAll('/', ''),
            builder: (context, state) {
              return TicketingMyRequest();
            },
          ),
          GoRoute(
            path: AppRoutes.viewTicketDetailsPath,
            name: AppRoutes.viewTicketDetails,
            builder: (context, state) {
              final ticketId = state.pathParameters['ticketId'] ?? '';
              return ViewTicketDetails(ticketId: ticketId);
            },
          ),
          GoRoute(
            path: AppRoutes.addNewRequest,
            name: AppRoutes.addNewRequest.replaceAll('/', ''),
            builder: (context, state) {
              return AddNewRequestPage();
            },
          ),
        ],
      ),
    ],
  );

  static FutureOr<String?> _redirect(
    BuildContext context,
    GoRouterState state,
  ) {
    final employeeState = context.read<EmployeeDetailCubit>().state;
    final currentLocation = state.matchedLocation;
    debugPrint('currentLocation:: $currentLocation, employeeState:: $employeeState');

    if (employeeState is EmployeeDetailInitial) {
      // While initial/restoring from cache, don't force redirect, let the current page show loading state
      return null;
    }

    final isAuthPage = currentLocation == AppRoutes.onboarding || 
                       currentLocation.startsWith('/user-login');

    if (employeeState is EmployeeDetailFetched) {
      // If logged in, don't allow accessing login or onboarding pages
      if (isAuthPage) {
        return AppRoutes.dashboardPath;
      }
      return null;
    }

    if (employeeState is EmployeeDetailCleared) {
      // If logged out, only allow accessing auth pages
      if (!isAuthPage) {
        return AppRoutes.onboarding;
      }
      return null;
    }

    return null;
  }
}
