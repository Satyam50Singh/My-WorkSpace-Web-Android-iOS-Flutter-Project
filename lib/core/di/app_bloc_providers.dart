import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_worksphere_web/features/auth/presentation/blocs/auto_bloc/auth_bloc.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';
import 'package:my_worksphere_web/features/ticketing/presentation/blocs/view_ticket_details_bloc/view_ticket_details_bloc.dart';

import '../../features/ticketing/presentation/blocs/my_ticket_request_bloc/ticketing_bloc.dart';
import 'injection_container.dart';

class AppBlocProviders {
  AppBlocProviders._();

  static List<BlocProvider> get providers => [
    BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
    BlocProvider<EmployeeDetailCubit>(create: (_) => sl<EmployeeDetailCubit>()),
    BlocProvider<TicketingBloc>(create: (_) => sl<TicketingBloc>()),
    BlocProvider<ViewTicketDetailsBloc>(create: (_) => sl<ViewTicketDetailsBloc>()),
  ];
}
