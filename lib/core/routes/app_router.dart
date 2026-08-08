import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:my_worksphere_web/features/auth/presentation/blocs/auto_bloc/auth_bloc.dart';

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
        path: AppRoutes.login,
        name: 'user-login',
        builder: (context, state) => const UserLoginPage(),
      ),
    ],
  );
}
