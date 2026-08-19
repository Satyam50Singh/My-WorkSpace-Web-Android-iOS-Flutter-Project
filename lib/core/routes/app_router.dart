import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/features/dashboard/presentation/pages/dashboard_home.dart';
import 'package:my_worksphere_web/features/dashboard/presentation/pages/employee_dashboard.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/pages/ticketing_my_request.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/pages/view_ticket_details.dart';

import '../../features/auth/presentation/pages/user_login_page.dart';
import '../../features/auth/presentation/pages/user_onboard_page.dart';
import 'app_routes.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.onboarding,
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
        ],
      ),
    ],
  );
}
