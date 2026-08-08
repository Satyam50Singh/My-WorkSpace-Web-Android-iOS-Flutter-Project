import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_worksphere_web/features/auth/presentation/blocs/auto_bloc/auth_bloc.dart';

import 'injection_container.dart';

class AppBlocProviders {
  AppBlocProviders._();

  static List<BlocProvider> get providers => [
    BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
  ];
}
