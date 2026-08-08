import 'package:go_router/go_router.dart';

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
    ],
  );
}
