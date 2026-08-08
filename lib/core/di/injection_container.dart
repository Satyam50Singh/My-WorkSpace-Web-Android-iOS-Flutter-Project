import 'package:get_it/get_it.dart';
import 'package:my_worksphere_web/features/auth/presentation/blocs/auto_bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ---------- Repositories ----------

  // ---------- Blocs / Cubits ----------
  sl.registerFactory(() => AuthBloc());
}
