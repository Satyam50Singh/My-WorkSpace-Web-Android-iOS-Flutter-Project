import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_worksphere_web/features/auth/presentation/cubit/employee_detail_cubit.dart';

class DashboardHome extends StatelessWidget {
  const DashboardHome({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMini = width < 360;
    final isMobile = width < 600;

    return BlocBuilder<EmployeeDetailCubit, EmployeeDetailState>(
      builder: (context, state) {
        if (state is EmployeeDetailFetched) {
          return Center(
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
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
